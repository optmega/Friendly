//
//  FRMyEventsHostCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsHostCell.h"
#import "UIImageView+WebCache.h"
#import "FRUserManager.h"
#import "FRStyleKit.h"

@interface FRMyEventsHostCell()

@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UIImageView* avatarView;

@end

@implementation FRMyEventsHostCell

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self title];
        [self avatarView];
        NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].currentUser.userPhoto]];
        [self.avatarView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image){
                self.avatarView.image = image;
            } else {
                self.avatarView.image = [FRStyleKit imageOfDefaultAvatar];
            }
             }];

    }
    return self;
}

- (void) updateAvatarPhoto
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].currentUser.userPhoto]];
    [self.avatarView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.avatarView.image = image;
    }];

}

#pragma mark - LazyLoad

- (UILabel*) title
{
    if (!_title)
    {
        _title = [UILabel new];
        [_title setText:@"What do you want to host?"];
        [_title setTextColor:[UIColor bs_colorWithHexString:@"#9CA0AB"]];
        [_title setFont:FONT_SF_DISPLAY_REGULAR(15)];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.avatarView.mas_right).offset(10);
        }];
    }
    return _title;
}

- (UIImageView*) avatarView
{
    if (!_avatarView)
    {
        _avatarView = [UIImageView new];
        _avatarView.layer.cornerRadius = 15.5;
        _avatarView.clipsToBounds = YES;
        _avatarView.backgroundColor = [UIColor blackColor];
        [self addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.width.equalTo(@31);
        }];
    }
    return _avatarView;
}
@end
