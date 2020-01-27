//
//  FRMyEventsMoreViewController.m
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsMoreViewController.h"
#import "FREventTransport.h"
#import "FRShareEventViewController.h"
#import "FRCreateEventInviteFriendsViewController.h"

@interface FRMyEventsMoreViewController()

@property (nonatomic, strong) UIButton* inviteFriendButton;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* deleteEventButton;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, strong) FREvent* model;

@end

@implementation FRMyEventsMoreViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self inviteFriendButton];
    [self shareButton];
    [self deleteEventButton];
    [self cancelButton];
    [self.cancelButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@240);
//    }];
}

-(void)updateWithEventId:(NSString*)eventId andModel:(FREvent*)model
{
    self.eventId = eventId;
    self.model = model;
}

- (void) showInviteWithEvent
{
    FRCreateEventInviteFriendsViewController* inviteVC = [FRCreateEventInviteFriendsViewController new];
    inviteVC.heightFooter = 240;
    [inviteVC updateWithEventId:self.model.eventId andEvent:self.model];
    inviteVC.isVCForCreating = NO;
    [self presentViewController:inviteVC animated:YES completion:nil];
}

-(void)deleteEvent
{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Warning"
                                                         message:@"Are you sure you want to delete this event?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                               otherButtonTitles:@"Yes", nil];
        [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [FREventTransport deleteEventWithId:self.eventId success:^{
            [self dismissViewControllerAnimated:YES
             completion:^{  
                 [self.delegate updateData];
             }];
        } failure:^(NSError *error) {
            //
        }];
    }
}

- (void) presentShareController
{
    FRShareEventViewController* vc = [FRShareEventViewController new];
    [vc updateWithEvent:self.model];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - LazyLoad

-(UIButton*) inviteFriendButton
{
    if (!_inviteFriendButton)
    {
        _inviteFriendButton = [UIButton new];
        [_inviteFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteFriendButton setTitle:@"Invite a friend" forState:UIControlStateNormal];
        [_inviteFriendButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        _inviteFriendButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_inviteFriendButton addTarget:self action:@selector(showInviteWithEvent) forControlEvents:UIControlEventTouchUpInside];
        _inviteFriendButton.layer.cornerRadius = 5;
        [self.footerView addSubview:_inviteFriendButton];
        [_inviteFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.footerView).offset(15);
            make.left.equalTo(self.footerView).offset(20);
            make.right.equalTo(self.footerView).offset(-20);
            make.height.equalTo(@45);

        }];
    }
    return _inviteFriendButton;
}

-(UIButton*) shareButton
{
    if (!_shareButton)
    {
        _shareButton = [UIButton new];
        [_shareButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [_shareButton setBackgroundColor:[UIColor whiteColor]];
        _shareButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        _shareButton.layer.cornerRadius = 5;
        [_shareButton addTarget:self action:@selector(presentShareController) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _shareButton.layer.borderWidth = 1;
        [self.footerView addSubview:_shareButton];
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inviteFriendButton.mas_bottom).offset(8);
            make.left.equalTo(self.footerView).offset(20);
            make.right.equalTo(self.footerView).offset(-20);
            make.height.equalTo(@45);

        }];
    }
    return _shareButton;
}

-(UIButton*) deleteEventButton
{
    if (!_deleteEventButton)
    {
        _deleteEventButton = [UIButton new];
        [_deleteEventButton setTitleColor:[UIColor bs_colorWithHexString:kAlertsColor] forState:UIControlStateNormal];
        [_deleteEventButton setTitle:@"Delete event" forState:UIControlStateNormal];
        [_deleteEventButton setBackgroundColor:[UIColor whiteColor]];
        _deleteEventButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_deleteEventButton addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
        _deleteEventButton.layer.cornerRadius = 5;
        _deleteEventButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _deleteEventButton.layer.borderWidth = 1;
        [self.footerView addSubview:_deleteEventButton];
        [_deleteEventButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareButton.mas_bottom).offset(8);
            make.left.equalTo(self.footerView).offset(20);
            make.right.equalTo(self.footerView).offset(-20);
            make.height.equalTo(@45);
        }];
    }
    return _deleteEventButton;
}

-(UIButton*) cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton new];
        [_cancelButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _cancelButton.layer.borderWidth = 1;
        [self.footerView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deleteEventButton.mas_bottom).offset(16);
            make.left.equalTo(self.footerView).offset(20);
            make.right.equalTo(self.footerView).offset(-20);
            make.height.equalTo(@45);
        }];
    }
    return _cancelButton;
}


@end
