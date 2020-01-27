//
//  FRHomeFriendsEventsSectionHeader.m
//  Friendly
//
//  Created by Sergey on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHomeFriendsEventsSectionHeader.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FRHomeFriendsEventsSectionHeader ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIImageView* arrowImage;

@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UIView* separator;

@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) FRHomeFriendsEventsSectionHeaderViewModel* model;
@property (nonatomic, assign) NSInteger imagesCount;

@property (nonatomic, strong) NSMutableArray* whiteViews;

@end

@implementation FRHomeFriendsEventsSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];

    self.contentView.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];

    self.subtitleLabel.text = @"See what your friends doing";
    self.backView.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    [self separator];
    UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectHeader)];
    
    [self.contentView addGestureRecognizer:gest];
    
    self.imagesCount =  [UIScreen mainScreen].bounds.size.width > 320 ? 4 : 3;
    return self;
}

- (void)selectHeader
{
    [self.model pressFriendsEvents];
}

- (void)update:(FRHomeFriendsEventsSectionHeaderViewModel*)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    [model updateUsers:self.images whiteView:self.whiteViews];
}


- (NSArray*)images
{
    if (!_images)
    {
        NSMutableArray* array = [NSMutableArray array];
        
        NSInteger rightOffset = 25;
    
    self.whiteViews = [NSMutableArray array];
    
    
        for (NSInteger i = 0; i< self.imagesCount; i++) {
            UIImageView* im = [UIImageView new];
            im.layer.cornerRadius = 16;
            im.hidden = true;
            im.clipsToBounds = YES;
            
            
            
            UIView* whiteBorder = [UIView new];
            whiteBorder.backgroundColor = [UIColor whiteColor];
            whiteBorder.layer.cornerRadius = 37/2;
            
            [self.backView addSubview:whiteBorder];
            [self.whiteViews addObject:whiteBorder];
            
//            [self.backView addSubview:im];
            
            [whiteBorder mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(@37);
                make.centerY.equalTo(self.backView);
                make.right.equalTo(self.arrowImage).offset(-(25 + i*rightOffset));
            }];
            
            [whiteBorder addSubview:im];
            
            [im mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(@32);
                make.center.equalTo(whiteBorder);
//                make.right.equalTo(self.arrowImage).offset(-(25 + i*rightOffset));
            }];
            
            
            [array addObject:im];
        }
        _images = array;
    }
    return _images;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.backView addSubview:_arrowImage];
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.centerY.equalTo(self.backView);
            make.right.equalTo(self.backView).offset(-10);
        }];
    }
    return _arrowImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_PROXIMA_NOVA_BOLD(16);
        [self.backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.mas_centerY);
            make.left.equalTo(self.backView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _subtitleLabel.font = FONT_PROXIMA_NOVA_REGULAR(13);
        [self.backView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView.mas_centerY);
            make.left.equalTo(self.backView).offset(20);
        }];
    }
    return _subtitleLabel;
}

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.contentView).offset(10);
        }];
    }
    return _backView;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end


@implementation FRHomeFriendsEventsSectionHeaderViewModel

- (void)pressFriendsEvents
{
    [self.delegate pressFriendsEvents];
}

- (NSString*)title
{    
    NSInteger count = [[[FRUserManager sharedInstance].currentUser friends] count];//[FRUserManager sharedInstance].currentUser.friends.count;
    NSString* str = count > 1 ? @"s" : @"";
    return [NSString stringWithFormat:@"%ld Friend%@ events", (long)count, str];
}

- (NSArray*)users
{
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    if ([FRUserManager sharedInstance].currentUser) {
        
        CurrentUser* user = [context objectWithID:[[FRUserManager sharedInstance].currentUser objectID]];
        return [[user friends] allObjects];
    }
         
         return @[];
}

- (void)updateUsers:(NSArray*)images whiteView:(NSArray*)whiteView
{
    NSArray* friends = [FRUserManager sharedInstance].currentUser.friends.allObjects;
    
    for (UIView* view in whiteView) {
        view.backgroundColor = [UIColor clearColor];
    }
    for (UIImageView* iv in images) {
        iv.image = nil;
    }
    
    [friends enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx >= images.count)
        {
            *stop = YES;
        }
        else
        {
        UserEntity* user = (UserEntity*)obj;
        UIImageView* iv = [images objectAtIndex:idx];
        NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:user.userPhoto]];
        
            [iv sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                iv.hidden = NO;
            }];
            
            UIView* view = whiteView[idx];
            view.backgroundColor = [UIColor whiteColor];
        }
    }];
}

@end
