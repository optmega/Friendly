//
//  FRCreateEventInviteCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteCell.h"
#import "FRStyleKit.h"

@interface FRCreateEventInviteCell ()

@property (nonatomic, strong) UIImageView*  backgroundPhoto;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* inviteButton;
@property (nonatomic, strong) UIButton* featureButton;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) FRCreateEventInviteCellViewModel* model;
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UIImageView* userPhoto;
@property (nonatomic, strong) UILabel* lastInviteLabel;

@property (nonatomic, strong) UIButton* deleteButton;

@end

@implementation FRCreateEventInviteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self backgroundPhoto];
        
        @weakify(self);
        [[self.inviteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model selectedInvite];
        }];
        [self titleLabel];
        
        [[self.featureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model selectedFeature];
        }];
        [self icon];
        [self deleteButton];
        self.backgroundColor = [UIColor whiteColor];
    
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventInviteCellViewModel*)model
{
    self.model = model;
    if (model.isForEditing)
    {
        self.deleteButton.hidden = NO;
        [_backgroundPhoto mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            //            make.bottom.equalTo(self.contentView).offset(2);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@225);
        }];
    }
    else
    {
        self.deleteButton.hidden = YES;
    }
    
    switch (self.model.featuredMode) {
        case FRCreateEventIvntiteTypeCannotFeatured:
        {
            [self.inviteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_centerX).offset(50);
            }];
            self.featureButton.hidden = true;
        } break;
            
        case FRCreateEventIvntiteTypeCanFeatured:
        {
            [self.inviteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_centerX).offset(-5);
            }];

            [self.featureButton setTitle:@"Feature" forState:UIControlStateNormal];
            self.featureButton.hidden = false;
        } break;
            
        case FRCreateEventIvntiteTypeCancelFeaured:
        {
            [self.inviteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_centerX).offset(-5);
            }];
            [self.featureButton setTitle:@"Cancel" forState:UIControlStateNormal];
            self.featureButton.hidden = false;
            
        } break;
            
        default:
            break;
    }
    
    if (model.fetureModel.invited_last) {
        [model updatePhoto:self.userPhoto];
        self.lastInviteLabel.attributedText = [model inviteTitle];
        self.userPhoto.hidden = false;
        self.lastInviteLabel.hidden = false;
    } else {
        self.lastInviteLabel.hidden = true;
        self.userPhoto.hidden = true;
    }
    
}


-(void)deleteEvent
{
    [self.model deleteEvent];
}

#pragma mark - Lazy Load

- (UIImageView*)backgroundPhoto
{
    if (!_backgroundPhoto)
    {
        _backgroundPhoto = [UIImageView new];
        _backgroundPhoto.image = [UIImage imageNamed:@"feature"];
        [self.contentView addSubview:_backgroundPhoto];
        
        [_backgroundPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.contentView).offset(2);
            make.top.equalTo(self.contentView).offset(20);
            make.height.equalTo(@225);
        }];
    }
    return _backgroundPhoto;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD([UIScreen mainScreen].bounds.size.width > 320 ? 20 : 18);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
//        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//        _titleLabel.shadowOffset = CGSizeMake(0, 2);
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:(@"Get featured free by bringing two\nFacebook friends to friendly")];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
//        _titleLabel.text = FRLocalizedString(@"Get featured free by bringing two\nFacebook friends to friendly", nil);
        _titleLabel.attributedText = attributedString;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.backgroundPhoto.mas_centerY);
            make.height.equalTo(@50);
            
        }];
    }
    return _titleLabel;
}

- (UIButton*)inviteButton
{
    if (!_inviteButton)
    {
        _inviteButton = [UIButton new];
        [_inviteButton setTitle:FRLocalizedString(@"Invite", nil) forState:UIControlStateNormal];
        _inviteButton.layer.cornerRadius = 5;
        _inviteButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(14);
        _inviteButton.backgroundColor = [UIColor bs_colorWithHexString:kFriendlyBlueColor];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_inviteButton];
        
        [_inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundPhoto.mas_centerY).offset(15);
            make.right.equalTo(self.contentView.mas_centerX).offset(-5);
            make.height.equalTo(@30);
            make.width.equalTo(@90);
        }];
    }
    return _inviteButton;
}

- (UIButton*)featureButton
{
    if (!_featureButton)
    {
        _featureButton = [UIButton new];
        _featureButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        _featureButton.layer.cornerRadius = 5;
        [_featureButton setTitle:FRLocalizedString(@"Feature", nil) forState:UIControlStateNormal];
        [_featureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_featureButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _featureButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(14);
        [self.contentView addSubview:_featureButton];
        
        [_featureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundPhoto.mas_centerY).offset(15);
            make.left.equalTo(self.inviteButton.mas_right).offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@90);
        }];
    }
    return _featureButton;
}

-(UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        [_icon setImage:[FRStyleKit imageOfFriendlyIcon]];
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-10);
            make.width.height.equalTo(@30);
        }];
    }
    return _icon;
}


- (UIButton*)deleteButton
{
    if (!_deleteButton)
    {
        _deleteButton = [UIButton new];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        [_deleteButton addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setTitle:FRLocalizedString(@"Delete event", nil) forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _deleteButton.titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(16);
        [self.contentView addSubview:_deleteButton];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
    }
    return _deleteButton;
}

- (UILabel*)lastInviteLabel
{
    if (!_lastInviteLabel)
    {
        _lastInviteLabel = [UILabel new];
        _lastInviteLabel.textColor = [UIColor whiteColor];
        _lastInviteLabel.font = FONT_SF_TEXT_REGULAR(12);
        [self.contentView addSubview:_lastInviteLabel];
        [_lastInviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inviteButton.mas_bottom).offset(25);
            make.centerX.equalTo(self.contentView).offset(15);
        }];
    }
    return _lastInviteLabel;
}

- (UIImageView*)userPhoto
{
    if (!_userPhoto)
    {
        _userPhoto = [UIImageView new];
        _userPhoto.layer.cornerRadius = 12;
        _userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
        _userPhoto.layer.borderWidth = 2;
        _userPhoto.clipsToBounds = true;
        [self.contentView addSubview:_userPhoto];
        [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@24);
            make.centerY.equalTo(self.lastInviteLabel);
            make.right.equalTo(self.lastInviteLabel.mas_left).offset(-5);
        }];
    }
    return _userPhoto;
}
@end
