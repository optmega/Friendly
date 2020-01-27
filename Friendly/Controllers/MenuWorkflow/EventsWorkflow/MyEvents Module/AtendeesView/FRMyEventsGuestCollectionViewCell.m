//
//  FRMyEventsGuestCollectionViewCell.m
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsGuestCollectionViewCell.h"
#import "FRStyleKit.h"
#import "UIImageView+AFNetworking.h"
#import "FRSettingsTransport.h"

@interface FRMyEventsGuestCollectionViewCell()

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* avatarImage;
@property (strong, nonatomic) NSString* userId;

@end

@implementation FRMyEventsGuestCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self avatarImage];
        [self nameLabel];
        [self checkedView];
    }
    return self;
}

- (void) discardUser
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Warning"
                                                message:@"You won't be able to add this user again. Are you sure you don't want this person on your event?"
                                                delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.delegate discardUser:self.userId forRow:self.rowNumber];
    }
}

- (void) updateWithModel:(MemberUser*)user andRowSelected:(NSInteger)row
{
    self.rowNumber = row;
    self.userId = user.userId;
    self.nameLabel.text = user.firstName;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:user.photo]];
}

- (void)showUserProfile
{
    UserEntity* user = [FRSettingsTransport getUserWithId:self.userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
    } failure:^(NSError *error) {
        //
    }];
    [self.delegate showUserProfileWithEntity:user];
}

#pragma mark - LazyLoad

-(UIButton*) checkedView
{
    if (!_checkedView)
    {
        _checkedView = [UIButton new];
        [_checkedView setBackgroundColor:[UIColor whiteColor]];
        [_checkedView setImage:[FRStyleKit imageOfAttendeeRemoveCanvas] forState:UIControlStateNormal];
        _checkedView.layer.cornerRadius = 10;
        _checkedView.layer.shadowColor = [UIColor blackColor].CGColor;
        _checkedView.layer.shadowOffset = CGSizeMake(0, 1);
        _checkedView.layer.shadowOpacity = 1;
        _checkedView.layer.shadowRadius = 2.0;
        _checkedView.clipsToBounds = YES;
        [_checkedView addTarget:self action:@selector(discardUser) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkedView];
        [_checkedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.right.top.equalTo(self.contentView);
        }];
    }
    return _checkedView;
}

-(UIImageView*) avatarImage
{
    if (!_avatarImage)
    {
        _avatarImage = [UIImageView new];
        _avatarImage.layer.cornerRadius = 35;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.userInteractionEnabled = YES;
        [_avatarImage setBackgroundColor:[UIColor blackColor]];
        [_avatarImage setImage:[FRStyleKit imageOfDefaultAvatar]];
        [self.contentView addSubview:_avatarImage];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatarImage addGestureRecognizer:singleTap];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@70);
            make.left.right.equalTo(self.contentView);
        }];
    }
    return _avatarImage;
}

-(UILabel*) nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        [_nameLabel setText:@"Name"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_nameLabel setFont:FONT_SF_DISPLAY_MEDIUM(15)];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.avatarImage.mas_bottom).offset(5);
        }];
    }
    return _nameLabel;
}

@end
