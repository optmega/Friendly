//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingInteractor.h"
#import "FRSettingsTransport.h"
#import "FRAuthTransportService.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FRBaseRoom.h"
#import "FRSettingWireframe.h"

@interface FRSettingInteractor ()

@property (nonatomic, strong) NSManagedObjectContext* context;

@end

@implementation FRSettingInteractor

- (NSManagedObjectContext*)context {
    
    _context = [NSManagedObjectContext MR_defaultContext];
    return _context;
}

- (void)loadData
{
    CurrentUser* currentUser = [self.context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
    [self.output dataLoaded:currentUser.setting];
    
    [FRSettingsTransport getSettingSuccess:^(Setting *model) {
            [self.output dataLoaded:model];
    } failure:^(NSError *error) {
//        [self.output showHudWithType:FRSettingHudTypeError title:@"error" message:error.localizedDescription];
    }];
    
}

- (void)saveSetting:(FRSettingDomainModel*)domainModel
{
    [FRSettingsTransport updateSetting:domainModel success:^{
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)logOut
{
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

        NSArray* currentUser = [CurrentUser MR_findAllInContext:context];
        [currentUser enumerateObjectsUsingBlock:^(CurrentUser*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj MR_deleteEntityInContext:context];
        }];
        
        NSArray* events = [FREvent MR_findAll];
        [events enumerateObjectsUsingBlock:^(FREvent*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj MR_deleteEntityInContext:context];
        }];
        
        NSArray* rooms = [FRBaseRoom MR_findAllInContext:context];
        [rooms enumerateObjectsUsingBlock:^(FRBaseRoom *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj MR_deleteEntityInContext:context];
        }];        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [FRAuthTransportService logoutSuccess:^{
            
        } failure:^(NSError *error) {
            
        }];
        [self.output logOuted];
    }];
    
    
}


+ (void)logOut:(BSCodeBlock)logout
{
    
    BSDispatchBlockToMainQueue(^{
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
            
            NSArray* currentUser = [CurrentUser MR_findAllInContext:context];
            [currentUser enumerateObjectsUsingBlock:^(CurrentUser*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj MR_deleteEntityInContext:context];
            }];
            
            NSArray* events = [FREvent MR_findAll];
            [events enumerateObjectsUsingBlock:^(FREvent*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj MR_deleteEntityInContext:context];
            }];
            
            NSArray* rooms = [FRBaseRoom MR_findAllInContext:context];
            [rooms enumerateObjectsUsingBlock:^(FRBaseRoom *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj MR_deleteEntityInContext:context];
            }];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
            
            
             [FRSettingWireframe Logout];
            if (logout) {
                
                logout();
            }
            
        }];
    });
    
    
    
    
}


- (void)cleanAndResetupDB
{
    [MagicalRecord cleanUp];
    
    NSString *dbStore = [MagicalRecord defaultStoreName];
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    NSURL *walURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"];
    NSURL *shmURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"];
    
    NSError *error = nil;
    BOOL result = YES;
    
    for (NSURL *url in @[storeURL, walURL, shmURL]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            result = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        }
    }
    
    if (result) {
        [MagicalRecord setupCoreDataStack];
    } else {
    }
}

@end
