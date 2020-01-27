//
//  FRSearchByCategoryMarkerView.m
//  Friendly
//
//  Created by User on 17.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryMarkerView.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"
#import "FREventPreviewController.h"
#import "CurrentUser.h"

@interface FRSearchByCategoryMarkerView()

@property (strong, nonatomic) FREvent* event;
@property (strong, nonatomic) UIButton* whiteView;
@property (strong, nonatomic) UserEntity* user;

@end

@implementation FRSearchByCategoryMarkerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self titleLabel];
        [self userAvatarView];
//        [self arrowButton];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 6;
        [self whiteView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)showEvent
{
    if (self.event) {
        
        [self.delegate showEventPreviewWithEvent:self.event];
    } else {
        [self.delegate showUserProfile:self.user];
    }
}

-(void)updateWithModel:(id)model
{
    if ([model isKindOfClass:[UserEntity class]]) {
        
        self.user = model;
        self.titleLabel.text = @"You";
        NSURL* url1 = [[NSURL alloc]initWithString:[NSObject bs_safeString:[self.user userPhoto]]];
//        [self.userAvatarView sd_setImageWithURL:url1 placeholderImage:[FRUserManager sharedInstance].logoImage];
        
        @weakify(self);
        [self.userAvatarView sd_setImageWithURL:url1 placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            BSDispatchBlockToMainQueue(^{
                @strongify(self);
                self.userAvatarView.image = image;
            });
        }];
        
        
    } else {
        
        self.event = [[NSManagedObjectContext MR_defaultContext] objectWithID:((NSManagedObject*)model).objectID];
        self.titleLabel.text = self.event.title;
        NSURL* url1 = [[NSURL alloc]initWithString:[NSObject bs_safeString:[[self.event creator] userPhoto]]];
//        [self.userAvatarView sd_setImageWithURL:url1];
        
        @weakify(self);
        [self.userAvatarView sd_setImageWithURL:url1 placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            BSDispatchBlockToMainQueue(^{
                @strongify(self);
                self.userAvatarView.image = image;
            });
        }];
    }
}

-(UIButton*) whiteView
{
    if (!_whiteView)
    {
        _whiteView = [UIButton new];
//        [_whiteView setBackgroundColor:[UIColor whiteColor]];
        [_whiteView setBackgroundImage:[UIImage imageNamed:@"event-selected"] forState:UIControlStateNormal];
//        _whiteView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _whiteView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        _whiteView.layer.shadowOpacity = 0.2f;
//        _whiteView.layer.shadowRadius = 0.5;
        _whiteView.layer.cornerRadius = 6;
        [_whiteView addTarget:self action:@selector(showEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_whiteView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(-0);
            make.bottom.equalTo(self).offset(0);
        }];
    }
    return _whiteView;
}

- (UIImageView*) userAvatarView
{
    if (!_userAvatarView)
    {
        _userAvatarView  = [UIImageView new];
        _userAvatarView.layer.cornerRadius = 13;
        _userAvatarView.clipsToBounds = true;
    
        [self.whiteView addSubview:_userAvatarView];
        [_userAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@26);
            make.centerY.equalTo(self).offset(-3);
            make.left.equalTo(self.whiteView).offset(12);
        }];
    }
    return _userAvatarView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [self.whiteView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userAvatarView);
            make.left.equalTo(self.userAvatarView.mas_right).offset(9);
            make.right.equalTo(self.whiteView).offset(-12);
        }];
    }
    return _titleLabel;
}

//- (UIButton*) arrowButton
//{
//    if (!_arrowButton)
//    {
//        _arrowButton = [UIButton new];
//        [_arrowButton setImage:[FRStyleKit imageOfFeildChevroneCanvas] forState:UIControlStateNormal];
//        [self.whiteView addSubview:_arrowButton];
//        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-4);
//            make.centerY.equalTo(self);
//            make.width.equalTo(@17);
//            make.height.equalTo(@17);
//        }];
//    }
//    return _arrowButton;
//}

@end
