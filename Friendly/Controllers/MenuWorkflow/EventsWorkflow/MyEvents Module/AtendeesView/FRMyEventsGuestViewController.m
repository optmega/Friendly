//
//  FRMyEventsGuestView.m
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsGuestViewController.h"
#import "FRStyleKit.h"
#import "FRMyEventsGuestCollectionViewCell.h"
#import "FRRequestTransport.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FRUserProfileWireframe.h"
#import "FRMyProfileWireframe.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FRSettingsTransport.h"

@interface FRMyEventsGuestViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FRMyEventsGuestCollectionViewCellDelegate, FBSDKAppInviteDialogDelegate>

@property (nonatomic, strong) UIButton* inviteFriendsButton;
@property (nonatomic, strong) UIButton* inviteFBFriendsButton;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UICollectionView* guestsCollectionView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) UILabel* titleLabel;
@property (strong, nonatomic) FRMyEventGuestViewModel* model;
@property (nonatomic, assign) BOOL isHosting;


@end

static CGFloat const kSideOffset = 15;

@implementation FRMyEventsGuestViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self footerView];
    [self headerView];
    [self closeButton];
    [self.closeButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self titleLabel];
    [self separator];
    [self guestsCollectionView];
    [self inviteFriendsButton];
    [self inviteFBFriendsButton];
    self.titleLabel.text = [NSString stringWithFormat:@"%lu Attendees", (unsigned long)self.users.count, nil];
    [self.guestsCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    setStatusBarColor([UIColor blackColor]);
}

- (void) showInviteWithEvent
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.delegate showInviteWithEvent:self.event.eventId andEvent:self.event];
//        FRCreateEventInviteFriendsViewController* inviteVC = [FRCreateEventInviteFriendsViewController new];
//        inviteVC.heightFooter = 240;
//        [inviteVC updateWithEventId:self.event.eventId andEvent:self.event];
//        inviteVC.isVCForCreating = NO;
//        [self presentViewController:inviteVC animated:YES completion:nil];

    }];
    }

- (void) openInviteDialog
{
    [FRSettingsTransport getInviteUrl:^(NSString *url) {
        
        FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
        content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:url]];
        content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://image.prntscr.com/image/d6d9e0d621b44c32a4c005d19d069652.png"];
        [FBSDKAppInviteDialog showFromViewController:self
                                         withContent:content
                                            delegate:self];
        
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];

}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.users.count;
}

-(void) updateWithHostingType
{
    self.isHosting = YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyEventsGuestCollectionViewCell *cell=(FRMyEventsGuestCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    if (self.isHosting)
    {
        cell.checkedView.hidden = NO;
    }
    else
    {
        cell.checkedView.hidden = YES;
    }
    [cell updateWithModel:[self.users objectAtIndex:indexPath.row] andRowSelected:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 80);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    FRMyEventsGuestCollectionViewCell* cell =  (FRMyEventsGuestCollectionViewCell*)[self.guestsCollectionView cellForItemAtIndexPath:indexPath];
    //
    return YES;
}

-(void)discardUser:(NSString *)userId forRow:(NSInteger)row
{
    [FRRequestTransport discardUserId:userId fromEventId:self.eventId success:^{
        [self.users removeObjectAtIndex:row];
        self.titleLabel.text = [NSString stringWithFormat:@"%lu Attendees", (unsigned long)self.users.count, nil];
        [self.guestsCollectionView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

-(void)showUserProfileWithEntity:(UserEntity *)user
{
    if ([user.user_id isEqualToString:[FRUserManager sharedInstance].currentUser.user_id])
    {
        FRMyProfileWireframe* wf = [FRMyProfileWireframe new];
        [wf presentMyProfileWithAnimationFrom:self];
        
    }
    else
    {
        FRUserProfileWireframe* wf = [FRUserProfileWireframe new];
        wf.complite = ^{
            setStatusBarColor([UIColor blackColor]);
        };
        [wf presentUserProfileFromViewController:self user:user fromLoginFlow:NO];
    }
}


#pragma mark - LazyLoad

- (UIButton*)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        UIImage *image = [FRStyleKit imageOfNavCloseCanvas];
        [_closeButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_closeButton.imageView setTintColor:[UIColor bs_colorWithHexString:@"#BCC0CB"]];
        [self.headerView addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.footerView).offset(20);
            make.left.equalTo(self.footerView).offset(kSideOffset);
            make.height.width.equalTo(@20);
        }];
    }
    return _closeButton;
}

- (UIView*)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        
        [self.footerView addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.footerView);
            make.height.equalTo(@54.5);
        }];
    }
    return _headerView;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.headerView addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headerView);
            make.left.equalTo(self.headerView).offset(kSideOffset);
            make.right.equalTo(self.headerView).offset(-kSideOffset);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.text = FRLocalizedString(@"0 Attendees", nil);
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.headerView);
        }];
    }
    return _titleLabel;
}

- (UICollectionView*) guestsCollectionView
{
    if (!_guestsCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _guestsCollectionView= [[UICollectionView alloc] initWithFrame:self.footerView.frame collectionViewLayout:layout];
        [layout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_guestsCollectionView registerClass:[FRMyEventsGuestCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_guestsCollectionView setDataSource:self];
        [_guestsCollectionView setDelegate:self];
        [_guestsCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.footerView addSubview:_guestsCollectionView];
        [_guestsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(10);
            make.left.equalTo(self.footerView);
            make.right.equalTo(self.footerView);
            make.height.equalTo(@105);
        }];
    }
    return _guestsCollectionView;
}

- (UIButton*)inviteFriendsButton
{
    if (!_inviteFriendsButton)
    {
        _inviteFriendsButton = [UIButton new];
        [_inviteFriendsButton setBackgroundColor:[UIColor whiteColor]];
        _inviteFriendsButton.layer.cornerRadius = 5;
        _inviteFriendsButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _inviteFriendsButton.layer.borderWidth = 1;
        [_inviteFriendsButton setTitle:@"Invite friends" forState:UIControlStateNormal];
        _inviteFriendsButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_inviteFriendsButton addTarget:self action:@selector(showInviteWithEvent) forControlEvents:UIControlEventTouchUpInside];
        [_inviteFriendsButton setTitleColor:[UIColor bs_colorWithHexString:@"808795"] forState:UIControlStateNormal];
        [self.footerView addSubview:_inviteFriendsButton];
        [_inviteFriendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guestsCollectionView.mas_bottom).offset(22);
            make.left.equalTo(self.footerView).offset(kSideOffset);
            make.height.equalTo(@51);
            make.right.equalTo(self.footerView).offset(-kSideOffset);
        }];
    }
    return _inviteFriendsButton;
}

- (UIButton*) inviteFBFriendsButton
{
    if (!_inviteFBFriendsButton)
    {
        _inviteFBFriendsButton = [UIButton new];
        [_inviteFBFriendsButton setBackgroundColor:[UIColor bs_colorWithHexString:@"2374CA"]];
        _inviteFBFriendsButton.layer.cornerRadius = 5;
        _inviteFBFriendsButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_inviteFBFriendsButton setTitle:@"Invite Facebook friends" forState:UIControlStateNormal];
        [_inviteFBFriendsButton addTarget:self action:@selector(openInviteDialog) forControlEvents:UIControlEventTouchUpInside];
        [_inviteFBFriendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.footerView addSubview:_inviteFBFriendsButton];
        [_inviteFBFriendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inviteFriendsButton.mas_bottom).offset(10);
            make.left.equalTo(self.footerView).offset(kSideOffset);
            make.height.equalTo(@51);
            make.right.equalTo(self.footerView).offset(-kSideOffset);
        }];

    }
    return _inviteFBFriendsButton;
}


@end
