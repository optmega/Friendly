//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatPresenter.h"
#import "FRPrivateChatDataSource.h"
#import "BSHudHelper.h"
#import "JSQMessage.h"
#import "FRPrivateMessage.h"
#import "FRUserManager.h"
#import "FRGroupRoom.h"
#import "FRGroupMessage.h"
#import "FRGroupUsersHeaderViewModel.h"
#import "JSQLocationMediaItem.h"
#import "FRPrivateChatUserHeaderViewModel.h"
#import "FRPrivateRoom.h"

#import "FREventTransport.h"
#import "FRGroupRoom.h"
#import "FRDateManager.h"
#import "FRSettingsTransport.h"

@interface FRPrivateChatPresenter () <FRPrivateChatDataSourceDelegate, FRGroupUsersHeaderViewModelDelegate>

@property (nonatomic, strong) FRPrivateChatDataSource* tableDataSource;
@property (nonatomic, strong) NSMutableDictionary* location;

@end

@implementation FRPrivateChatPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRPrivateChatDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRPrivateChatViewInterface>*)userInterface event:(FREvent*)eventT
{
    FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:eventT.objectID];
    self.userInterface = userInterface;
    [self.userInterface setupWithRoomId:[event eventId]];
    [self.userInterface updateDataSource:self.tableDataSource event:(FREvent*)event];
    
    [self.interactor loadChatForEvent:event];
}

- (void)loadOldMessageWithCount:(NSInteger)count
{
    [self.interactor loadOldMessages:count];
}



#pragma mark - Output

- (void)oldMessageLoaded {
    [self.userInterface  oldMessageLoaded];
}

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRPrivateChatHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)updateMessageData:(NSArray*)message
{
    NSArray* mesModels = [self _messageModel:message];
    [self.userInterface updateMessages:mesModels];
}

- (void)recivedMessage:(FRBaseMessage*)message
{

    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    message = [context objectWithID:message.objectID];
    JSQMessage* mes = [self locationMessage:message];
    
    if (!mes) {
    
        mes = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%@", message.creatorId]
                                 senderDisplayName:@""//obj.firstName
                                              date:message.createDate
                                              text:message.messageText];
    }
    mes.messageStatus = message.messageStatus.integerValue;
    mes.messageId = message.messageId;
    
    if ([message.creatorId integerValue] == [[FRUserManager sharedInstance].userModel.id integerValue])
    {
        [self.userInterface updateLastMessage:mes];
        return;
    }
    
    mes.avatarUrl = message.userPhoto;
    [self.userInterface recivedMessage:mes];
}

- (void)locationShared:(NSString*)locationMessage
{
    FRBaseMessage* message = [FRBaseMessage MR_createEntity];
    message.messageText = locationMessage;
    message.createDate = [NSDate date];
    message.creatorId = [[FRUserManager sharedInstance] userId];
    
    JSQMessage* mes = [self locationMessage:message];
    
    [self.userInterface recivedMessage:mes];

    [message MR_deleteEntity];
}

- (void)userPhotoLoaded:(NSDictionary *)userPhotos
{
//    [self.userInterface updateUserPhotos:userPhotos];
}

- (void)loadeTitle:(NSString*)title image:(NSString*)imageUrl
{
    [self.userInterface updateTitle:title image:imageUrl];
}

- (void)showUserProfile
{
//    [self.wireframe presentUserProfileId:[NSString stringWithFormat:@"%ld", (long)self.interactor.room.userId]];
}

- (JSQMessage*)createJSQMessage:(FRBaseMessage*)message
{
    
    JSQMessage* mes = [self locationMessage:message];
    
    if (!mes) {
        
        mes = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%@", message.creatorId]
                                 senderDisplayName:@""//obj.firstName
                                              date:message.createDate
                                              text:message.messageText];
    }
    mes.messageStatus = message.messageStatus.integerValue;
    mes.messageId = message.messageId;
    
    return mes;
}

- (JSQMessage*)locationMessage:(FRBaseMessage*)message
{
    
    
    NSError* error;
    NSData* jsonData = [message.messageText dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary* json = [[NSJSONSerialization JSONObjectWithData: jsonData
                                                          options: NSJSONReadingMutableContainers
                                                            error: &error] objectForKey:@"MyLocation"];
    
    JSQMessage* mes;
    if (error)
    {
        return nil;
    }
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:[[json objectForKey:@"lat"] doubleValue] longitude:[[json objectForKey:@"lon"] doubleValue]];
    
    JSQLocationMediaItem* locationItem = [self.location objectForKey:message.messageId ?: @"temp"];
    if (!locationItem) {
        
        locationItem = [[JSQLocationMediaItem alloc] initWithLocation:location];
        [self.location setObject:locationItem forKey:[message messageId] ?: @"temp"];
    }
    
    locationItem.appliesMediaViewMaskAsOutgoing = [message.creatorId isEqualToString:[[FRUserManager sharedInstance].currentUser user_id]];
    mes = [[JSQMessage alloc] initWithSenderId:message.creatorId
                             senderDisplayName:@""
                                          date:message.createDate
                                         media:locationItem];
    return mes;
}

- (NSMutableDictionary*)location {
    if(!_location) {
        _location = [NSMutableDictionary dictionary];
    }
    
    return _location;
}


#pragma mark - private

- (NSArray*)_messageModel:(NSArray*)model
{
    NSMutableArray* messageModels = [NSMutableArray array];
    NSMutableDictionary* photosDict = [NSMutableDictionary dictionary];
    
    [model enumerateObjectsUsingBlock:^(FRBaseMessage* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        
        JSQMessage *message = [self locationMessage:obj];
        if (!message) {
            message = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%@", obj.creatorId]
                                                 senderDisplayName:obj.firstName ? obj.firstName : @""
                                                              date:obj.createDate
                                                              text:obj.messageText];
        }
        message.messageStatus = obj.messageStatus.integerValue;
        message.messageId = obj.messageId;
        
        [photosDict setObject:[NSObject bs_safeString:obj.userPhoto] forKey:[NSString stringWithFormat:@"%@", obj.creatorId]];
        
        
        message.avatarUrl = obj.userPhoto;
        [messageModels addObject:message];
    }];
    
    [self.userInterface updateUserPhotos:photosDict];
    return messageModels;
}


//- (FRGroupUsersHeaderViewModel*)_createGroupHeader:(FRGroupRoom*)groupRoom
//{
//    FRGroupUsersHeaderViewModel* model = [FRGroupUsersHeaderViewModel new];
//    model.users = groupRoom.members.allObjects;
//    if (groupRoom.joined_at) {
//        model.subtitle = [NSString stringWithFormat:@"YOU JOINED ON THE %@", [FRDateManager dateStringFromDate:groupRoom.joined_at withFormat:@"dd/MM/yyyy"]];
//    }
//    model.delegate = self;
//    return model;
//}

- (void)selectUser:(UserEntity*)entity {
    [self.wireframe presentUserProfile:entity];
}

#pragma mark - Module Interface

- (void)showUserProfileWithId:(NSString*)userId {
    [self.interactor userEntityForId:userId];
}

- (void)showEvent {
    [self.wireframe showEvent:self.interactor.eventForChat];
}

- (void)backSelected
{
    [self.wireframe dismissPrivateChatController];
}

- (void)sendMessage:(NSString*)text
{
    [self.interactor sendMessage:text];
}

- (void)shareLocation
{
    [self.interactor shareLocation];
}

- (void)showEventWithID:(NSString*)eventId
{
    [self.wireframe presentEventControllerWithEventId:eventId];
}

- (void)leaveEvent {
    [self.interactor leaveEvent];
}

- (void)deleteEvent {
    [self.interactor deleteEvent];
}

#pragma mark - FRGroupUsersHeaderViewModelDelegate

- (void)selectedUsersId:(NSString*)userId
{
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:nil failure:nil];
    [self.wireframe presentUserProfile:user];
}

@end
