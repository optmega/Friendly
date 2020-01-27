//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfilePresenter.h"
#import "FRUserProfileDataSource.h"
#import "BSHudHelper.h"
#import "FRFriendsTransport.h"


@interface FRUserProfilePresenter () <FRUserProfileDataSourceDelegate>

@property (nonatomic, strong) FRUserProfileDataSource* tableDataSource;

@end

@implementation FRUserProfilePresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRUserProfileDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRUserProfileViewInterface>*)userInterface user:(UserEntity*)user
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.tableDataSource setupStorage];
    [self.interactor loadDataWithUser:user];
   
}


#pragma mark - Output

- (void)dataLoadedWithUserModel:(UserEntity*)userT mutual:(NSArray*)mutual;
{
//    BOOL isPrivateAccount = false;
    
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:userT.objectID];
    NSSet* users = [[[FRUserManager sharedInstance].currentUser friends] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", [user user_id]]];
//    if (!users.count) {
//        isPrivateAccount = user.privateAccount.boolValue;
//    }
    [self.userInterface updateWithPrivateAccount:(!users.count || !([user.isFriend boolValue]))];
    [self.tableDataSource updateStorageWithUserModel:user withMutual:mutual isPrivateAccount:user.privateAccount.boolValue];
}

- (void)showHudWithType:(FRUserProfileHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissUserProfileController];
}

- (void)updateData
{
    [self.interactor updateData];
}

- (void)messageSelected

{
    [self.wireframe presentChatWithUser:self.interactor.user];
}

#pragma mark - DataSource

- (void)updateWallImage:(NSString *)imageUrl
{
    [self.userInterface updateWallImage:imageUrl];
}
- (void)saveSelected
{
    
}

- (void)inviteToEventSelected:(NSString*)userId
{
    [self.wireframe presentInviteToEventController:userId];
}

- (void)addFriendSelected:(NSString*)userId
{
    [FRFriendsTransport inviteFriendsWithId:userId message:@"" success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}

- (void)settingSelected:(NSString*)userId
{
    [self.wireframe presentInputControllerWithUserId:userId];
}


- (void)selectedStatus:(NSString*)status userId:(NSString*)userId
{
     if ([status isEqualToString:@"Block user"]) {
           [self.interactor blockUserWithId:userId];
     }
    else if ([status isEqualToString:@"Report user"])
    {
        [self.interactor reportUserWithId:userId];
    }
    else if ([status isEqualToString:@"Remove user"])
    {
        [self.interactor removeUserWithId:userId];
    }
    
    

//      UIAlertController *alert = [UIAlertController
//                                alertControllerWithTitle:FRLocalizedString(@"Delete event", nil)
//                                message:FRLocalizedString(@"Are you sure you want to block this user?", nil)
//                                preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addAction: [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil)
//                                               style:UIAlertActionStyleDefault
//                                             handler:nil ]];
//    [alert addAction:[UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil)
//                                              style:UIAlertActionStyleDefault
//                                            handler:^(UIAlertAction * _Nonnull action) {
//                                              
//                                                [self.interactor blockUser];
//
//    }]];
//    [self.userInterface presentViewController:alert animated:NO completion:nil];
//    
}

- (void)connectInstagram
{
    [self.wireframe presentInstagramAuthController];
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.wireframe presentPreviewControllerWithImage:image];
}

- (void)showUserProfile:(NSString*)userId
{
    [self.wireframe presentUserProfileControllerWithUserId:userId];
}

@end
