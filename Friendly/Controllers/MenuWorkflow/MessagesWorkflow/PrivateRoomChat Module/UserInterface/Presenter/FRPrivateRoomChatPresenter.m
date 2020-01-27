//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatPresenter.h"
#import "FRPrivateRoomChatDataSource.h"
#import "BSHudHelper.h"
#import "JSQMessages.h"
#import "FRBaseMessage.h"
#import "FRPrivateChatUserHeaderViewModel.h"

@interface FRPrivateRoomChatPresenter () <FRPrivateRoomChatDataSourceDelegate>

@property (nonatomic, strong) FRPrivateRoomChatDataSource* tableDataSource;
@property (nonatomic, strong) NSMutableDictionary* location;

@end

@implementation FRPrivateRoomChatPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRPrivateRoomChatDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRPrivateRoomChatViewInterface>*)userInterface userEntity:(UserEntity*)user
{
    
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    self.userInterface.titleImage = user.userPhoto;
    self.userInterface.titleString = user.firstName;
    
    
    FRPrivateChatUserHeaderViewModel* headerModel = [FRPrivateChatUserHeaderViewModel initWithModel:user];
    
    [self.userInterface updatePrivateHeader:headerModel];
    [self.userInterface userId:user.user_id];
    [self.interactor loadDataWithUser:user];
}


#pragma mark - Output

- (void)dataLoadedWithRoomId:(NSString *)roomId
{
    [self.userInterface setupWithRoomId:roomId];
}

- (void)showHudWithType:(FRPrivateRoomChatHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
    if (type == FRPrivateRoomChatHudTypeError) {
        [self.wireframe dismissPrivateRoomChatController];
    }
}

- (JSQMessage*)createJSQMessage:(FRBaseMessage*)message
{
    
    JSQMessage* mes = [self locationMessage:message];
    
    if (!mes) {
        
        mes = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%@", [message creatorId]]
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
    
    JSQLocationMediaItem* locationItem = [self.location objectForKey:message.messageId ?: message.opponentId];
    if (!locationItem) {
        
        locationItem = [[JSQLocationMediaItem alloc] initWithLocation:location];
        [self.location setObject:locationItem forKey:message.messageId ?: message.opponentId];
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

- (void)messageLoaded {
    [self.userInterface oldMessageLoaded];
}


#pragma mark - Module Interface

- (void)viewWillAppear {
    
//    CurrentUser *currentUser = [[FRUserManager sharedInstance] currentUser];
//    
//    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:[self.interactor user].objectID];
//    
//    if ([currentUser.friends containsObject:user] || [user.user_id isEqualToString:WELCOME_TEMP_USER]) {
//
//    } else {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You can not send messages" message:@"The user has to be your friend." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self.wireframe dismissPrivateRoomChatController];
//        }];
//        
//        [alert addAction:cancel];
//        
//        [self.userInterface presentViewController:alert animated:true completion:nil];
//    }
    
}

- (UserEntity*)userEntity {
    return [self.interactor user];
}

- (void)backSelected
{
    [self.wireframe dismissPrivateRoomChatController];
}

- (void)sendMessage:(NSString*)message {
    [self.interactor sendMessage:message];
}

- (NSString*)roomId {
    return [self.interactor roomId];
}

- (void)shareLocation {
    [self.interactor shareLocation];
}

- (void)loadOldMessageWithCount:(NSInteger)count
{
    [self.interactor loadOldMessageWithCount:count];
}

- (void)removeUser {
    [self.interactor removeUser];
}

- (void)blockUser {
    [self.interactor blockUser];
}
- (void)reportUser {
    [self.interactor reportUser];
}
- (void)inviteToUser {
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.interactor.user.objectID];
    [self.wireframe presentInviteToEventController:user.user_id];
}

- (void)showUserProfile:(NSString*)userId {
    [self.wireframe presentUserProfile:[self.interactor user]];
}

@end
