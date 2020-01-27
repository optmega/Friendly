//
//  FRMyEventsToolbar.m
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsToolbar.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"
#import "FRMyProfileWireframe.h"
#import "FRUserManager.h"
#import "UIImageHelper.h"

@interface FRMyEventsToolbar()

@property (strong, nonatomic) UIButton* avatarButton;
@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UIButton* refreshButton;
@property (strong, nonatomic) UIButton* badge;

@end

@implementation FRMyEventsToolbar

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.translucent = NO;
        self.barTintColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        [self avatarButton];
        
        [self.avatarButton addTarget:self action:@selector(showUserProfile) forControlEvents:UIControlEventTouchUpInside];
        
        [self.refreshButton addTarget:self action:@selector(showEventRequests) forControlEvents:UIControlEventTouchUpInside];
        
        [self title];
        self.badge.hidden = YES;
        [self refreshButton];
        
//        NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].userModel.photo]];
//        [self.avatarButton.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [self.avatarButton setImage:image forState:UIControlStateNormal];
//        }];

    }
    return self;
}

- (void) updateAvatarPhoto
{
//    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].userModel.photo]];
//    [self.avatarButton.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.avatarButton setImage:image forState:UIControlStateNormal];
//    }];
}

- (void) updateBadgeWithCount:(NSInteger)count_
{

    if (count_ < 1) {
        self.badge.hidden = true;
        return;
    }
    
    self.badge.hidden = false;
    NSString* count = count_ < 100 ? [NSString stringWithFormat:@" %ld ", (long)count_] : @" >99 ";
    
    [self.badge setTitle:count forState:UIControlStateNormal];
    [self.badge.titleLabel sizeToFit];
    CGFloat width = self.badge.titleLabel.bounds.size.width < 19 ? 19 : self.badge.titleLabel.bounds.size.width;
    
    [self.badge mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@18);
    }];

    
//    if (count>0)
//    {
//        self.badge.hidden = NO;
//        [self.badge setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
//    }
//    else
//    {
//        self.badge.hidden = YES;
//    }
}



- (void)showUserProfile
{
    [self.delegate showSearch];
}

- (void)showEventRequests
{
    [self.delegate showEventRequests];
}

#pragma mark - LazyLoad

-(UIButton*) avatarButton
{
    if (!_avatarButton)
    {
        _avatarButton = [UIButton new];
//        _avatarButton.layer.cornerRadius = 15;
//        _avatarButton.backgroundColor = [UIColor blackColor];
//        _avatarButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//        _avatarButton.layer.borderWidth = 2;
//        _avatarButton.clipsToBounds = YES;
          [_avatarButton setImage:[UIImageHelper image:[FRStyleKit imageOfPage1Canvas4] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [self addSubview:_avatarButton];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-8);
            make.right.equalTo(self).offset(-17);
            make.height.width.equalTo(@30);
        }];
    }
    return _avatarButton;
}

-(UILabel*) title
{
 if (!_title)
 {
     _title = [UILabel new];
     [_title setText:@"Events"];
     [_title setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
     [_title setFont:FONT_SF_DISPLAY_SEMIBOLD(18)];
     [self addSubview:_title];
     [_title mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
         make.bottom.equalTo(self).offset(-15);
     }];
 }
    return _title;
}

-(UIButton*) refreshButton
{
    if (!_refreshButton)
    {
        _refreshButton = [UIButton new];
        [_refreshButton setImage:[UIImageHelper image:[FRStyleKit imageOfGroup5Canvas] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [self addSubview:_refreshButton];
        [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.bottom.equalTo(self).offset(-8);
            make.left.equalTo(self).offset(16);
        }];
    }
    return _refreshButton;
}

-(UIButton*) badge
{
    if (!_badge)
    {
        _badge = [UIButton new];
        [_badge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _badge.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        _badge.layer.cornerRadius = 9;
//        _badge.layer.shadowRadius = 1;
//        _badge.layer.shadowColor = [UIColor blackColor].CGColor;
//        _badge.layer.shadowOpacity = 0.7f;
//        _badge.layer.shadowOffset = CGSizeMake(0, 1);
        [_badge setBackgroundColor:[UIColor bs_colorWithHexString:@"FE0000"]];
        [self.refreshButton addSubview:_badge];
        [_badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18);
            make.height.equalTo(@19);
            make.top.equalTo(self.refreshButton);
            make.right.equalTo(self.refreshButton).offset(8);
        }];
    }
    return _badge;
}

@end
