//
//  FRFriendRequestsCell.m
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsCell.h"
#import "FRSettingsTransport.h"

@interface FRFriendRequestsCell ()



@property (nonatomic, strong) FRFriendRequestsCellViewModel* model;

@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, strong) UIView* separator;

@end


@implementation FRFriendRequestsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.buttonWidth = [[UIScreen mainScreen] bounds].size.height <= 568.0f ? 60 : 80;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
        
        
        [self.acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.declineButton addTarget:self action:@selector(declineAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self separator];
        
    }
    return self;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@(0.5));
        }];
    }
    return _separator;
}

- (void)showUserProfile
{
    
  [self.model showUserProfileWithEntity:nil];
}

- (void)acceptAction:(UIButton*)sender
{
    [self.model selectedAccept];
}

- (void)declineAction:(UIButton*)sender
{
    [self.model selectedDecline];
}

- (void)updateWithModel:(FRFriendRequestsCellViewModel*)model
{
    self.model = model;
    
    [self.model updatePhotoImage:self.photoImage];
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.statusImage.hidden = NO;//!model.isBusy;
}



#pragma mark - Lazy Load

- (UIImageView*)photoImage
{
    if (!_photoImage)
    {
        _photoImage = [UIImageView new];
        _photoImage.backgroundColor = [UIColor grayColor];
        _photoImage.clipsToBounds = YES;
        _photoImage.layer.cornerRadius = 22.5;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_photoImage addGestureRecognizer:singleTap];
        _photoImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoImage];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@45);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _photoImage;
}

- (UIView*)statusBackView
{
    if (!_statusBackView)
    {
        _statusBackView = [UIView new];
        _statusBackView.backgroundColor = [UIColor whiteColor];
        _statusBackView.layer.cornerRadius = 6;
        
        [self.contentView addSubview:_statusBackView];
        [_statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@12);
            make.centerX.equalTo(self.photoImage.mas_right).offset(-3);
            make.bottom.equalTo(self.mas_centerY).offset(-4);
        }];
    }
    return _statusBackView;
}


- (UIImageView*)statusImage
{
    if (!_statusImage)
    {
        _statusImage = [UIImageView new];
        _statusImage.layer.cornerRadius = 5;
        _statusImage.clipsToBounds = YES;
        _statusImage.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        [self.statusBackView addSubview:_statusImage];
        
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@10);
            make.centerX.equalTo(self.photoImage.mas_right).offset(-3);
            make.bottom.equalTo(self.mas_centerY).offset(-5);
        }];
    }
    return _statusImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.photoImage.mas_right).offset(5);
            make.right.equalTo(self.acceptButton.mas_left).offset(-5);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"58677C"];
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.photoImage.mas_right).offset(5);
            make.right.equalTo(self.acceptButton.mas_left).offset(-5);

        }];
    }
    return _subtitleLabel;
}

- (UIButton*)acceptButton
{
    if (!_acceptButton)
    {
        _acceptButton = [UIButton new];
        _acceptButton.layer.cornerRadius = 4;
        [_acceptButton setTitle:FRLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _acceptButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _acceptButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _acceptButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self addSubview:_acceptButton];
        
        [_acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@(self.buttonWidth));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.declineButton.mas_left).offset(-5);
        }];
    }
    return _acceptButton;
}

- (UIButton*)declineButton
{
    if (!_declineButton)
    {
        _declineButton = [UIButton new];
        _declineButton.backgroundColor = [UIColor whiteColor];
        [_declineButton setTitle:FRLocalizedString(@"Decline", nil) forState:UIControlStateNormal];
        [_declineButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_declineButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        _declineButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _declineButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _declineButton.layer.cornerRadius = 6;
        _declineButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _declineButton.layer.borderWidth = 1;
        [self addSubview:_declineButton];
        
        [_declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.buttonWidth));
            make.height.equalTo(@30);
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _declineButton;
}


@end
