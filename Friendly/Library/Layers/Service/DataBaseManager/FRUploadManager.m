//
//  FRUploadManager.m
//  Friendly
//
//  Created by Sergey on 02.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUploadManager.h"
#import "FREventTransport.h"
#import "CreateEvent.h"
#import "FRUploadImage.h"
#import "UIImageHelper.h"
#import "FRGroupRoom.h"
#import "FRLoaderView.h"
#import "FRRequestTransport.h"
#import "FRCalendarManager.h"

@interface FRUploadManager()

+ (instancetype)sharedInstance;

@property (nonatomic, strong) FRLoaderView* loaderView;

@end


@implementation FRUploadManager

+ (instancetype)sharedInstance {
    
    static FRUploadManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FRUploadManager new];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loaderView = [[NSBundle mainBundle] loadNibNamed:@"FRLoaderView" owner:self options:nil].firstObject;
        self.loaderView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 47);
    }
    return self;
}

+ (void)uploadEvent {
    NSArray* events = [CreateEvent MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isUpdate == %@", @(false)]];
    
    
    for (CreateEvent* ev in events) {
        
        [[[self sharedInstance] loaderView] updateWithEvent: ev];
        
        BSDispatchBlockToMainQueue(^{
            if (![[self sharedInstance] loaderView].superview)
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_UPLOAD_VIEW object:[[self sharedInstance] loaderView]];
            
//                [[[UIApplication sharedApplication] keyWindow] addSubview:[[self sharedInstance] loaderView]];
        });
        
        FREventDomainModel* domenModel = [ev domainModel];
        if (!ev.image_url && domenModel.placeImage) {
            
            [FRUploadImage uploadImage:[UIImageHelper addFilter:domenModel.placeImage]
                              complite:^(NSString *imageUrl) {
               
                                  ev.image_url = imageUrl;
                                  [self createEvent:ev];
                
                              } failute:^(NSError *error) {
                                  [self removeLoadView];
                              }];
        } else {
            [self createEvent:ev];
        }
    }
}


+ (void)createEvent:(CreateEvent*)ev {
    
    [FREventTransport createEventWithModel:[ev domainModel] success:^(FREvent *event)
     {

         NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
         
         [FRGroupRoom initOrUpdateGroupRoomWithModel:event inContext:context];
         
         
        [self addEventToCalendar:event];
         
         
         FREvent* tempEvent = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
         
         if ([ev requests].length > 0)
             [FRRequestTransport sendInviteToEvent:tempEvent.eventId toUserId:[ev requests] success:^{} failure:^(NSError *error) {}];
         
         [ev MR_deleteEntity];
         [context MR_saveToPersistentStoreAndWait];
         [ev.managedObjectContext MR_saveToPersistentStoreAndWait];
         
         [self removeLoadView];
     } failure:^(NSError *error) {
         [self removeLoadView];
     }];
}

+ (void)updateEvent {
    
     NSArray* events = [CreateEvent MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isUpdate == %@", @(true)]];
    
    for (CreateEvent* ev in events) {
        
        [[[self sharedInstance] loaderView] updateWithEvent: ev];
        
        BSDispatchBlockToMainQueue(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_UPLOAD_VIEW object:[[self sharedInstance] loaderView]];
//            [[[UIApplication sharedApplication] keyWindow] addSubview:[[self sharedInstance] loaderView]];
        });
        
        if (ev.image_url)
        {
            [self update:ev];
            continue;
        }
        
        [FRUploadImage uploadImage:[UIImage imageWithData:ev.placeImage] complite:^(NSString *imageUrl) {
            ev.image_url = imageUrl;
            
            [self update:ev];
            
        } failute:^(NSError *error) {
            [self removeLoadView];
        }];
    }
}

+ (void)update:(CreateEvent*)ev {

    
    [FREventTransport updateEventWithId:ev.eventId event:[ev domainModel] success:^(FREventModel* event) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
            [self removeLoadView];
            if ([ev requests].length > 0)
                [FRRequestTransport sendInviteToEvent:event.id toUserId:[ev requests] success:^{} failure:^(NSError *error) {}];
        
        
        [ev MR_deleteEntityInContext:context];
            [FREvent initWithEvent:event inContext:context];
        [context MR_saveToPersistentStoreAndWait];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_EVENT object:nil];
        
    } failure:^(NSError *error) {
        [self removeLoadView];
    }];
    
}


+ (void)removeLoadView {
    BSDispatchBlockToMainQueue(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImageProgress" object:@(100) userInfo:nil];

        BSDispatchBlockAfter(0.5, ^{
            
            [[[self sharedInstance] loaderView] removeFromSuperview];
        });
    });
}

+ (void)addEventToCalendar:(FREvent*)event {
    
    [[FRCalendarManager sharedInstance] addEvent:event
                                  fromController:[UIApplication sharedApplication].keyWindow.rootViewController
                                 complitionBlock:^{}];
}

@end
