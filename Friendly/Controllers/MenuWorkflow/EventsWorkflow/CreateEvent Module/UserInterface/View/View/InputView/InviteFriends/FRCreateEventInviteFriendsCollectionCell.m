//
//  FRCreateEventInviteFriendsCollectionCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteFriendsCollectionCell.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"

@class  FRUserModel;

@interface FRCreateEventInviteFriendsCollectionCell()

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* avatarImage;
@property (strong, nonatomic) FRUserModel* userModel;

@end

@implementation FRCreateEventInviteFriendsCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self avatarImage];
        [self nameLabel];
        [self checkedView];
        self.checkedView.hidden = YES;
        self.isChecked = NO;
    }
    return self;
}

- (void) updateCellWithCheckedView
{
    if (self.isChecked)
    {
        self.checkedView.hidden = YES;
        self.isChecked = NO;
    }
    else
    {
        self.checkedView.hidden = NO;
        self.isChecked = YES;
    }
    [self.delegate updateFrame:self.isChecked];
}

- (void) updateWithModel:(FRUserModel*)model
{
    self.userModel = model;
    self.nameLabel.text = self.userModel.first_name;
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:self.userModel.photo]];
    [self.avatarImage sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    
}

#pragma mark - LazyLoad

-(UIView*) checkedView
{
    if (!_checkedView)
    {
        _checkedView = [UIImageView new];
        [_checkedView setImage:[FRStyleKit imageOfAttendeeCheckmarkCanvas]];
        _checkedView.clipsToBounds = YES;
        _checkedView.layer.cornerRadius = 10;
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
        _avatarImage.layer.cornerRadius = 30;
        _avatarImage.clipsToBounds = YES;
//        [_avatarImage setBackgroundColor:[UIColor magentaColor]];
        [_avatarImage setImage:[FRStyleKit imageOfDefaultAvatar]];
        _avatarImage.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        [self.contentView addSubview:_avatarImage];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@60);
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
        //[_nameLabel setText:@"Name"];
        [_nameLabel setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_nameLabel setFont:FONT_SF_DISPLAY_MEDIUM(15)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
       // _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.avatarImage.mas_bottom).offset(5);
        }];
    }
    return _nameLabel;
}


@end
