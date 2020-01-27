//
//  FREventRequestsToJoinCell.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsToJoinCell.h"
#import "UIImageView+WebCache.h"
#import "FRRequestTransport.h"
#import "FRSettingsTransport.h"
#import "FRStyleKit.h"

@interface FREventRequestsToJoinCell()

@property (nonatomic, strong) UIImageView* avatar;
@property (nonatomic, strong) UILabel* nameAgeLabel;
@property (nonatomic, strong) UILabel* distanceLabel;
@property (nonatomic, strong) UILabel* messageLabel;
@property (nonatomic, strong) UILabel* dateTimeLabel;
@property (nonatomic, strong) UIButton* acceptButton;
@property (nonatomic, strong) UIButton* declineButton;
@property (nonatomic, strong) UIView* isAvailable;
@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) FREventRequestsToJoinRequestModel* model;

@end

#define kButtonWidth ([UIScreen mainScreen].bounds.size.width/2-20)/2)


@implementation FREventRequestsToJoinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self avatar];
        [self nameAgeLabel];
        [self distanceLabel];
        [self messageLabel];
        [self dateTimeLabel];
        [self acceptButton];
        [self declineButton];
        [self separator];
        [self isAvailable];
    }
    return self;
}

- (void) updateWithModel:(FREventRequestsToJoinRequestModel*)model
{
    self.model = model;
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.avatar]];
    [self.avatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    if ([model.age isEqualToString:@"0"])
    {
        self.nameAgeLabel.text = model.name;
    }
    else
    {
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %@",model.name, model.age];
    }

//    self.nameAgeLabel.text =[NSString stringWithFormat:@"%@, %@", model.name, model.age];
    self.messageLabel.text = model.message;
    self.dateTimeLabel.text = model.datetimeRequest;
    self.distanceLabel.text =[NSString stringWithFormat:@"%.1fkm away",[model.model.way integerValue]  / 1000.];
}

-(void)showProfile
{
    UserEntity* user = [FRSettingsTransport getUserWithId:self.model.model.userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
    } failure:^(NSError *error) {
        //
    }];
    [self.delegate showUserProfileWithEntity:user];
}

- (void) acceptUser
{
    [FRRequestTransport acceptRequestForRequestId:self.model.requestId success:^{
        [self.delegate reloadData];
                } failure:^(NSError *error) {
            //
        }];
}

- (void) declineUser
{
    [FRRequestTransport declineRequestForId:self.model.requestId success:^{
        [self.delegate reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark - LazyLoad

-(UIImageView*) avatar
{
    if (!_avatar)
    {
        _avatar = [UIImageView new];
        _avatar.clipsToBounds = YES;
        [_avatar setBackgroundColor:[UIColor blackColor]];
        _avatar.layer.cornerRadius = 20;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatar addGestureRecognizer:singleTap];
        _avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatar];
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.width.height.equalTo(@40);
        }];
    }
    return _avatar;
}

-(UILabel*) nameAgeLabel
{
    if (!_nameAgeLabel)
    {
        _nameAgeLabel = [UILabel new];
        [_nameAgeLabel setText:@"Brian, 28"];
        [_nameAgeLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        _nameAgeLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [self.contentView addSubview:_nameAgeLabel];
        [_nameAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.bottom.equalTo(self.avatar.mas_centerY);
        }];
    }
    return _nameAgeLabel;
}

-(UILabel*) distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [UILabel new];
        [_distanceLabel setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [_distanceLabel setText:@"1.8km away"];
        _distanceLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.top.equalTo(self.avatar.mas_centerY);
        }];
    }
    return _distanceLabel;
}

-(UIButton*) acceptButton
{
    if (!_acceptButton)
    {
        _acceptButton = [UIButton new];
        [_acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        [_acceptButton addTarget:self action:@selector(acceptUser) forControlEvents:UIControlEventTouchUpInside];
        _acceptButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _acceptButton.layer.cornerRadius = 5;
        [_acceptButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [self.contentView addSubview:_acceptButton];
        [_acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.nameAgeLabel);
            make.bottom.equalTo(self.distanceLabel);
            make.width.equalTo(@(kButtonWidth);
        }];
     }
     return _acceptButton;
}
                               
-(UIButton*) declineButton
{
    if (!_declineButton)
    {
    _declineButton = [UIButton new];
    [_declineButton setTitle:@"Decline" forState:UIControlStateNormal];
    [_declineButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
    [_declineButton addTarget:self action:@selector(declineUser) forControlEvents:UIControlEventTouchUpInside];
    _declineButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
    _declineButton.layer.borderWidth = 1;
    _declineButton.layer.cornerRadius = 5;
    _declineButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
    [self.contentView addSubview:_declineButton];
    [_declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.acceptButton.mas_right).offset(5);
             make.top.equalTo(self.acceptButton);
             make.height.equalTo(self.acceptButton);
             make.width.equalTo(@(kButtonWidth);
     }];
     }
     return _declineButton;
}

-(UILabel*) messageLabel
{
    if (!_messageLabel)
    {
    _messageLabel = [UILabel new];
    [_messageLabel setText:@"Massive craft beer lover! Could suggest a few pleases I know if you like?"];
    _messageLabel.numberOfLines = 2;
    _messageLabel.font = FONT_SF_DISPLAY_REGULAR(15);
    [_messageLabel sizeToFit];
    _messageLabel.textColor = [UIColor bs_colorWithHexString:kIconsColor];
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameAgeLabel);
        make.right.equalTo(self.declineButton).offset(-20);
        make.top.equalTo(self.acceptButton.mas_bottom).offset(10);
    }];
    }
    return _messageLabel;
}

-(UILabel*) dateTimeLabel
{
    if (!_dateTimeLabel)
    {
        _dateTimeLabel = [UILabel new];
        [_dateTimeLabel setText:@"17/02/2016 5:39 PM"];
        _dateTimeLabel.textColor = [UIColor bs_colorWithHexString:kWatermarkColor];
        _dateTimeLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        [self.contentView addSubview:_dateTimeLabel];
        [_dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageLabel);
            make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
        }];
    }
    return _dateTimeLabel;
}

-(UIView*) separator
{
    if(!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateTimeLabel).offset(5);
            make.bottom.equalTo(self.contentView).offset(1);
            make.height.equalTo(@1);
            make.right.equalTo(self.declineButton);
        }];
    }
    return _separator;
}

-(UIView*) isAvailable
{
        if (!_isAvailable)
        {
            UIView* whiteBackground = [UIView new];
            [whiteBackground setBackgroundColor:[UIColor whiteColor]];
            whiteBackground.layer.cornerRadius = 4.5;
            [self.contentView addSubview:whiteBackground];
            [whiteBackground mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@9);
                make.right.top.equalTo(self.avatar);
             }];
            _isAvailable = [UIView new];
            [_isAvailable setBackgroundColor:[UIColor bs_colorWithHexString:kAlertsColor]];
//            _isAvailable.frame = CGRectInset(_isAvailable.frame, -1, -1);
//            _isAvailable.layer.borderColor = [UIColor whiteColor].CGColor;
//            _isAvailable.layer.borderWidth = 1;
            _isAvailable.layer.cornerRadius = 3.5;
            [whiteBackground addSubview:_isAvailable];
            [_isAvailable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(whiteBackground);
                make.width.height.equalTo(@7);
                }];
        }
        return _isAvailable;
}



@end
