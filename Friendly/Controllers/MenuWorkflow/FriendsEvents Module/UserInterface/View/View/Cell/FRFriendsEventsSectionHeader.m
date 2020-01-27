//
//  FRFriendsEventsSectionHeader.m
//  Friendly
//
//  Created by Sergey on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsSectionHeader.h"
#import "FRStyleKit.h"

@interface FRFriendsEventsSectionHeader ()

@property (nonatomic, strong) FRInviteFriendsCellViewModel* model;
@property (nonatomic, strong) UIImageView* iconFBImage;
@property (nonatomic, strong) UIImageView* arrowImage;
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* subtitle;
@property (nonatomic, strong) UIView* separatorView;

@end

@implementation FRFriendsEventsSectionHeader


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.contentView addGestureRecognizer:gest];
    
    [self title];
    [self subtitle];
    [self separatorView];

    
    
    return self;
}

- (void)tapAction:(id)sender
{
    [self.model inviteFriendsSelected];
}

- (void)updateWithModel:(id)model
{
    self.model = model;
}

#pragma mark - LazyLoad

- (UIImageView*)iconFBImage
{
    if (!_iconFBImage)
    {
        _iconFBImage = [UIImageView new];
        _iconFBImage.image = [FRStyleKit imageOfFeildFacebookCanvasGray];
        [self.contentView addSubview:_iconFBImage];
        [_iconFBImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            //            make.top.equalTo(self.contentView).offset(22.5);
            make.height.width.equalTo(@30);
            make.bottom.equalTo(self.contentView).offset(-17);
            
        }];
    }
    return _iconFBImage;
}

- (UILabel*)title
{
    if (!_title)
    {
        _title = [UILabel new];
        _title.text = @"Invite your friends";
        _title.font = FONT_SF_DISPLAY_MEDIUM(17);
        _title.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconFBImage.mas_right).offset(15);
            make.right.equalTo(self.arrowImage.mas_left).offset(-10);
            make.bottom.equalTo(self.iconFBImage.mas_centerY);
        }];
    }
    return _title;
}

- (UILabel*)subtitle
{
    if (!_subtitle)
    {
        _subtitle = [UILabel new];
        _subtitle.text = @"and share instant access between your events";
        _subtitle.font = FONT_SF_DISPLAY_REGULAR(12);
        _subtitle.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.contentView addSubview:_subtitle];
        [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconFBImage.mas_right).offset(15);
            make.right.equalTo(self.arrowImage.mas_left).offset(-10);
            make.bottom.equalTo(self.iconFBImage);
        }];
    }
    return _subtitle;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_arrowImage];
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.equalTo(@20);
        }];
    }
    return _arrowImage;
}

- (UIView*)separatorView
{
    if (!_separatorView)
    {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.bottom.right.equalTo(self.contentView);
        }];
    }
    return _separatorView;
}

@end