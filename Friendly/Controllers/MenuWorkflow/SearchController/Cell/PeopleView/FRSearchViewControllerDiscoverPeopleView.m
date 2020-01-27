//
//  FRSearchViewControllerDiscoverPeopleView.m
//  Friendly
//
//  Created by Jane Doe on 5/10/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerDiscoverPeopleView.h"
#import "FRSearchUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRUserModel.h"
#import "FRStyleKit.h"

@interface FRSearchViewControllerDiscoverPeopleView()

@property (strong, nonatomic) UIImageView* firstView;
@property (strong, nonatomic) UIImageView* secondView;
@property (strong, nonatomic) UIImageView* thirdView;
@property (strong, nonatomic) NSMutableArray* photos;

@property (nonatomic, strong) UIView* whiteBorder1;
@property (nonatomic, strong) UIView* whiteBorder2;
@property (nonatomic, strong) UIView* whiteBorder3;

@end

@implementation FRSearchViewControllerDiscoverPeopleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self firstView];
        [self secondView];
        [self thirdView];
        self.photos = [NSMutableArray array];
        [self bringSubviewToFront:self.firstView];
        [self insertSubview:self.secondView aboveSubview:self.thirdView];
    }
    return self;
}

-(void)updateWithUsers:(NSArray*)users
{
    
    self.whiteBorder1.hidden =
    self.whiteBorder2.hidden =
    self.whiteBorder3.hidden = true;
    
    [self.photos removeAllObjects];
    [self makeViewsWhite];
    NSInteger k = users.count;
    if (users.count>3) {
        k = 3;
    }
    if (k > 0)
    {
    for (int i = 0; i<k; i++)
    {
    if (users[i])
    {
    FRUserModel* userModel = [users objectAtIndex:i];
        if (userModel.photo) {
            [self.photos addObject:userModel.photo];
        }
        else
        {
            [self.photos addObject:@""];
        }
    }
    }
    if (k>0)
    {
        NSURL* url1 = [[NSURL alloc]initWithString:[NSObject bs_safeString:self.photos[0]]];
        [self.thirdView sd_setImageWithURL:url1 placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
        self.thirdView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.whiteBorder3.hidden = false;

    }
    if (k>1)
    {
        NSURL* url2 = [[NSURL alloc]initWithString:[NSObject bs_safeString:self.photos[1]]];
        [self.secondView sd_setImageWithURL:url2 placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
        self.secondView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.whiteBorder2.hidden = false;

    }
    if (k>2)
    {
        NSURL* url3 = [[NSURL alloc]initWithString:[NSObject bs_safeString:self.photos[2]]];
        [self.firstView sd_setImageWithURL:url3 placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
        self.firstView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.whiteBorder1.hidden = false;
    }
    }
}

-(void) makeViewsWhite
{
    [self.firstView setImage:nil];
    [self.secondView setImage:nil];
    [self.thirdView setImage:nil];
    self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
    self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
    self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
}
#pragma mark - LazyLoad

- (UIImageView*)firstView
{
    if (!_firstView)
    {
        _firstView = [UIImageView new];
        _firstView.layer.cornerRadius = 25;
        _firstView.clipsToBounds = YES;
        _firstView.layer.borderColor = [UIColor clearColor].CGColor;
//        _firstView.layer.borderWidth = 2;
        
        
        [_firstView setBackgroundColor:[UIColor clearColor]];
        _firstView.layer.zPosition = 6;
        [self addSubview:_firstView];
        [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.height.equalTo(@50);
            make.right.equalTo(self.secondView.mas_left).offset(20);
        }];
    
        self.whiteBorder1 = [UIView new];
        self.whiteBorder1.layer.zPosition = 5;
        self.whiteBorder1.backgroundColor = [UIColor whiteColor];
        self.whiteBorder1.layer.cornerRadius = 27;
        [self addSubview:self.whiteBorder1];
        
        [self.whiteBorder1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_firstView);
            make.height.width.equalTo(@54);
        }];
        
    
    }
    
    return _firstView;
}

- (UIImageView*)secondView
{
    if (!_secondView)
    {
        _secondView = [UIImageView new];
        _secondView.layer.cornerRadius = 25;
        _secondView.clipsToBounds = YES;
        _secondView.layer.borderColor = [UIColor clearColor].CGColor;
//        _secondView.layer.borderWidth = 2;
        _secondView.layer.zPosition = 4;
        
        [_secondView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_secondView];
        [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.height.equalTo(@50);
            make.right.equalTo(self.thirdView.mas_left).offset(20);
        }];
        self.whiteBorder2 = [UIView new];
        self.whiteBorder2.layer.zPosition = 3;
        self.whiteBorder2.backgroundColor = [UIColor whiteColor];
        self.whiteBorder2.layer.cornerRadius = 27;
        [self addSubview:self.whiteBorder2];
        
        [self.whiteBorder2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_secondView);
            make.height.width.equalTo(@54);
        }];
    }
    
    return _secondView;
}

- (UIImageView*)thirdView
{
    if (!_thirdView)
    {
        _thirdView = [UIImageView new];
        _thirdView.layer.cornerRadius = 25;
        _thirdView.clipsToBounds = YES;
        _thirdView.layer.borderColor = [UIColor clearColor].CGColor;
        _thirdView.layer.zPosition = 2;
        [_thirdView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_thirdView];
        [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.height.equalTo(@50);
            make.right.equalTo(self);
        }];
        
        self.whiteBorder3 = [UIView new];
        self.whiteBorder3.layer.zPosition = 1;
        self.whiteBorder3.backgroundColor = [UIColor whiteColor];
        self.whiteBorder3.layer.cornerRadius = 27;
        [self addSubview:self.whiteBorder3];
        
        [self.whiteBorder3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_thirdView);
            make.height.width.equalTo(@54);
        }];

    }
    return _thirdView;
}

@end
