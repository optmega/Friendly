//
//  FRCreateEventInviteFriendsInputView.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteFriendsViewController.h"
#import "FRCreateEventInviteFriendsCollectionCell.h"
#import "FRStyleKit.h"
#import "FRFriendsTransport.h"
#import "FRFriendsListModel.h"
#import "FRRequestTransport.h"
#import <FBSDKShareKit/FBSDKGameRequestContent.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import "FRSettingsTransport.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImageHelper.h"
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKAppInviteContent.h>
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKShareKit/FBSDKSharing.h>
#import "BSHudHelper.h"
#import "FRAnimator.h"

@protocol FBSDKAppInviteDialogDelegate;
@protocol FRSDKGameRequestDialogDelegate;

@interface FRCreateEventInviteFriendsViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FRInviteFriendsCollectionCellDelegate, UITextFieldDelegate, FBSDKAppInviteDialogDelegate, FBSDKGameRequestDialogDelegate>

@property (strong, nonatomic) NSMutableArray* friendsToSendIdArray;
@property (strong, nonatomic) NSMutableArray* friendsToSendNamesArray;
@property (strong, nonatomic) FBSDKAppInviteDialog* inviteDialog;
@property (strong, nonatomic) FREvent* event;
@property (strong, nonatomic) NSNumber* page;
@property (strong, nonatomic) NSMutableArray* arrayToShow;
@property (nonatomic, strong) MASConstraint* bottom;
@property (assign, nonatomic) int pageCount;
@end

@implementation FRCreateEventInviteFriendsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightFooter = 240;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self inviteFriendsView];
       self.friendsToSendIdArray = [NSMutableArray array];
    self.friendsArray = [NSMutableArray array];
    self.arrayToShow = [NSMutableArray array];
    self.friendsToSendNamesArray = [NSMutableArray array];
    self.counter = 0;
    if (self.eventId == nil) {
        self.eventId = @"0";
    }
    self.page = @1;
    [self getData];

//    [FRFriendsTransport getCandidatesListWithEvent:self.eventId page:page success:^(FRCandidatesListModel *friendsList) {
//        self.friendsArray = [NSMutableArray arrayWithArray:friendsList.friends];
//        self.arrayToShow = [NSMutableArray arrayWithArray:friendsList.friends];
//        [self.friendsCollectionView reloadData];
//    } failure:^(NSError *error) {
//        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
//    }];
    

    [self titleLabel];
    [self friendsCollectionView];
    self.searchView.hidden = YES;
    self.searchView.searchField.delegate = self;
    [self.searchView.searchField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
//    self.friendsCollectionView.pagingEnabled = YES;
    if (!self.isVCForCreating)
    {
        [self.inviteFriendsView.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.inviteFBButton.hidden = NO;
    }
    else
    {
        [self.inviteFriendsView.cancelButton setTitle:@"Done" forState:UIControlStateNormal];
        self.inviteFBButton.hidden = YES;
    }
    [self inviteFBButton];
    [self.searchView.closeButton addTarget:self action:@selector(hideSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteFriendsView.closeButton setImage:[FRStyleKit imageOfPage1Canvas4] forState:UIControlStateNormal];
    [self.inviteFriendsView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteFriendsView.cancelButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }

-(void)updateWithEventId:(NSString*)eventId andEvent:(FREvent *)event
{
    self.eventId = eventId;
    self.event = event;
}

-(void)getData
{
    [FRFriendsTransport getCandidatesListWithEvent:self.eventId page:self.page success:^(FRCandidatesListModel *friendsList, NSString* pageCount) {
        [self.friendsArray addObjectsFromArray:friendsList.friends];
        [self.arrayToShow addObjectsFromArray:friendsList.friends];
        self.pageCount = [pageCount intValue];
        [self.friendsCollectionView reloadData];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];

}

-(void)textFieldDidChange
{
    NSString* name = self.searchView.searchField.text;
    NSMutableArray * array = [NSMutableArray array];
        for (FRUserModel * object in self.friendsArray) {
            if ([object.first_name containsString:name])
            {
                [array addObject:object];
            }
        }
    self.arrayToShow = array;
    if ([self.searchView.searchField.text isEqualToString:@""])
    {
        self.arrayToShow = self.friendsArray;
    }
    [self.friendsCollectionView reloadData];
}

-(void)openMessenger
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    NSURL* url = [NSURL URLWithString:self.event.imageUrl];

    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    image = [UIImageHelper drawText:self.event.title inImage:image atPoint:CGPointMake(20, 20)];
    [FBSDKMessengerSharer shareImage:image withOptions:nil];
    [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
}

+(void)openInviteDialogFromVC:(UIViewController*)viewController delegate:(id)delegate
{
//    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
//    gameRequestContent.message = @"Take this bomb to blast your way to victory!";
////    gameRequestContent.recip = @[@"RECIPIENT_USER_ID"];
////    gameRequestContent.objectID = @"YOUR_OBJECT_ID";
////    gameRequestContent.actionType = @"ACTION_TYPE";
//    
//    // Assuming self implements <FBSDKGameRequestDialogDelegate>
//    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
//
    
    
    
    
    
//    FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
//    content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:@"http://friendlyapp-test.r-savchenko.com/api/fb/u/invitation/146"]];
//    
//    [FBSDKAppInviteDialog showFromViewController:self
//                                     withContent:content
//                                        delegate:self];
    
    
    [FRSettingsTransport getInviteUrl:^(NSString *url) {
        
        FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
        content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://image.prntscr.com/image/d6d9e0d621b44c32a4c005d19d069652.png"];
        
        content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:url]];
        [FBSDKAppInviteDialog showFromViewController:viewController
                                         withContent:content
                                            delegate:delegate];
        
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
    
    
//    FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
//    content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:@"https://fb.me/1723371957911186"]];
//    
//    [FBSDKAppInviteDialog showFromViewController:self
//                                     withContent:content
//                                        delegate:self];
    
//    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
//    content.appLinkURL = [NSURL URLWithString:@"http://www.mobiledeeplinking.org/product/123"];
    
    
    //optionally set previewImageURL
//    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
   
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"me" parameters:nil];
        
        FBSDKGraphRequest *requestLikes = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"/me/apprequests" parameters:nil];
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process me information
             }];
        [connection addRequest:requestLikes
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
             }];
        [connection start];
    }
}
 
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}



- (void)closeAction:(UIButton*)sender
{
    if (sender == self.inviteFriendsView.closeButton)
    {
        [self makeFrameSearch];
    }
    else if (sender == self.inviteFriendsView.cancelButton)
    {
        if (self.friendsToSendIdArray.count)
        {
            if (!self.isVCForCreating)
            {
//                for (int i = 0; i<self.friendsToSendIdArray.count; i++)
//                {
//                    [FRRequestTransport sendInviteToEvent:self.eventId toUserId:self.friendsToSendIdArray[i] success:^{
//                
//                    } failure:^(NSError *error) {
//                    //
//                    }];
//                }
                
                NSString* stringFromArray = [NSString new];
                for (int i = 0; i<self.friendsToSendIdArray.count; i++)
                {
                    stringFromArray = [stringFromArray stringByAppendingString:[NSString stringWithFormat:@"%@,", self.friendsToSendIdArray[i]]];
                }
                stringFromArray = [stringFromArray substringToIndex:[stringFromArray length]-1];
                [FRRequestTransport sendInviteToEvent:self.event.eventId toUserId:stringFromArray success:^{
                    
                }
                                              failure:^(NSError *error) {
                                                  //
                                              }];
                

            }
            else
            {
                [self.delegate selectedFriends:self.friendsToSendNamesArray withIdArray:self.friendsToSendIdArray];
            }
        }
        [self makeFrameOriginal];
        [self closeVC];
    }
}

- (void) hideSearch:(id)sender
{
    [self.searchView.searchField resignFirstResponder];
    self.titleLabel.hidden = NO;
    if (!self.isVCForCreating)
    {
        self.inviteFBButton.hidden = NO;
    }
    else
    {
        self.inviteFBButton.hidden = YES;
    }
    self.searchView.hidden = YES;
}

- (void) updateFrame:(BOOL)isSomethingChecked
{
    if (isSomethingChecked)
    {
    self.counter++;
    [self makeFrameWithMessage];
    }
    else
    {
    self.counter--;
    }
    if (!(self.counter > 0))
    {
       [self makeFrameOriginal];
    }
}

- (void) makeFrameWithMessage
{
//    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@280);
//    }];
//    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@280);
//    }];
//    [self messageField];
//    self.messageField.hidden = NO;
    if (!self.isVCForCreating)
    {
        [self.inviteFriendsView.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.inviteFriendsView.cancelButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.inviteFriendsView.cancelButton setTitle:@"Send invite" forState:UIControlStateNormal];
    }
}

- (void) makeFrameSearch
{
    self.titleLabel.hidden = YES;
    self.inviteFBButton.hidden = YES;
    self.searchView.hidden = NO;
    [self.searchView.searchField becomeFirstResponder];
}

- (void) makeFrameOriginal
{
//    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@240);
//    }];
//    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@240);
//    }];
    if (!self.isVCForCreating)
    {
        [self.inviteFriendsView.cancelButton setBackgroundColor:[UIColor whiteColor]];
        [self.inviteFriendsView.cancelButton setTitleColor:[UIColor bs_colorWithHexString:@"8a909d"] forState:UIControlStateNormal];
        [self.inviteFriendsView.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
//    self.messageField.hidden = YES;
}


#pragma mark - TextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;
    CGFloat durationAnimation;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&durationAnimation];
    
    [self.view setNeedsLayout];
    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];
    
    [UIView animateWithDuration:durationAnimation animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;
    CGFloat durationAnimation;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&durationAnimation];
    
    [self.view setNeedsLayout];
    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:durationAnimation animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CollectionViewDelegate
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    CGFloat width = ([UIScreen mainScreen].bounds.size.width-255)/4;
//    return width;
//}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.item == self.arrayToShow.count - 3)&&([self.page intValue] < self.pageCount ))
    {
        int value = [self.page intValue];
        self.page = [NSNumber numberWithInt:value + 1];
        [self getData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 10;
    return self.arrayToShow.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCreateEventInviteFriendsCollectionCell *cell=(FRCreateEventInviteFriendsCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.isChecked = NO;
    cell.checkedView.hidden = YES;
    FRUserModel* user = [self.arrayToShow objectAtIndex:indexPath.row];
    if ([self.friendsToSendIdArray containsObject:user.id])
    {
        [cell updateCellWithCheckedView];
    }
    [cell updateWithModel:[self.arrayToShow objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   FRCreateEventInviteFriendsCollectionCell* cell =  (FRCreateEventInviteFriendsCollectionCell*)[self.friendsCollectionView cellForItemAtIndexPath:indexPath];
    [cell updateCellWithCheckedView];
    FRUserModel* user = [self.arrayToShow objectAtIndex:indexPath.row];
    if ([self.friendsToSendIdArray containsObject:user.id])
    {
        NSInteger index = [self.friendsToSendIdArray indexOfObject:user.id];
        [self.friendsToSendIdArray removeObject:user.id];
        [self.friendsToSendNamesArray removeObjectAtIndex:index];
    }
    else
    {
        [self.friendsToSendIdArray addObject:user.id];
        [self.friendsToSendNamesArray addObject:user.first_name];
    }
    return YES;
}


#pragma mark - LazyLoad

- (FRCreateEventBaseInpute*) inviteFriendsView
{
    if (!_inviteFriendsView)
    {
        _inviteFriendsView = [FRCreateEventBaseInpute new];
        _inviteFriendsView.layer.masksToBounds = YES;
        [self.footerView addSubview:_inviteFriendsView];
        [_inviteFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.footerView);
        }];
    }
    return _inviteFriendsView;
}

- (FRCreateEventInviteFriendsSearchView*)searchView
{
    if (!_searchView)
    {
        _searchView = [FRCreateEventInviteFriendsSearchView new];
        [self.inviteFriendsView.headerView addSubview:_searchView];
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.inviteFriendsView.headerView);
            make.centerY.equalTo(self.inviteFriendsView.headerView);
            make.height.equalTo(@45);
            make.left.equalTo(self.inviteFriendsView.closeButton.mas_right).offset(5);
        }];
    }
    return _searchView;
}

//- (UITextField*) messageField
//{
//    if (!_messageField)
//    {
//        _messageField = [UITextField new];
//        _messageField.placeholder = @"Write a message...";
//        [_messageField setFont:FONT_SF_DISPLAY_LIGHT(14)];
//        _messageField.autocorrectionType = UITextAutocorrectionTypeYes;
//        _messageField.delegate = self;
//        _messageField.layer.cornerRadius = 8;
//        _messageField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
//        _messageField.backgroundColor = [UIColor bs_colorWithHexString:@"#EFF1F6"];
//        [self.inviteFriendsView addSubview:_messageField];
//        [_messageField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.friendsCollectionView.mas_bottom).offset(5);
//            make.left.equalTo(self.inviteFriendsView).offset(15);
//            make.right.equalTo(self.inviteFriendsView).offset(-15);
//            make.height.equalTo(@35);
//        }];
//    }
//    return _messageField;
//}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.text = FRLocalizedString(@"Invite a friend", nil);
        [self.inviteFriendsView.headerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.inviteFriendsView.headerView.mas_centerX);
            make.centerY.equalTo(self.inviteFriendsView.headerView);
        }];
    }
    return _titleLabel;
}

- (FRCreateEventInviteFriendsFacebookButton*) inviteFBButton
{
    if (!_inviteFBButton)
    {
        _inviteFBButton = [FRCreateEventInviteFriendsFacebookButton new];
//       [_inviteFBButton addTarget:self action:@selector(openInviteDialog) forControlEvents:UIControlEventTouchUpInside];
        [_inviteFBButton addTarget:self action:@selector(openMessenger) forControlEvents:UIControlEventTouchUpInside];
        [self.inviteFriendsView.headerView addSubview:_inviteFBButton];
        [_inviteFBButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.inviteFriendsView.headerView).offset(-15);
            make.centerY.equalTo(self.inviteFriendsView.headerView);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
    }
    return _inviteFBButton;
}

- (UICollectionView*) friendsCollectionView
{
    if (!_friendsCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _friendsCollectionView= [[UICollectionView alloc] initWithFrame:self.inviteFriendsView.frame collectionViewLayout:layout];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-285)/4;
        [layout setMinimumLineSpacing:width];
        [layout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_friendsCollectionView registerClass:[FRCreateEventInviteFriendsCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_friendsCollectionView setDataSource:self];
        [_friendsCollectionView setDelegate:self];
        [_friendsCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.inviteFriendsView addSubview:_friendsCollectionView];
        [_friendsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inviteFriendsView.headerView.mas_bottom).offset(10);
           // make.left.equalTo(self.inviteFriendsView).offset(15);
            make.left.right.equalTo(self.inviteFriendsView);
            make.height.equalTo(@100);
        }];
    }
    return _friendsCollectionView;
}

@end
