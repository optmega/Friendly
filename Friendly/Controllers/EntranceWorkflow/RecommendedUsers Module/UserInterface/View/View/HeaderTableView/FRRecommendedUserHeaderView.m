//
//  FRRecommendedUserHeaderView.m
//  Friendly
//
//  Created by Sergey Borichev on 03.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUserHeaderView.h"
#import "FRHeaderQuestionairView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRRecommendedUserHeaderView ()

@property (nonatomic, strong) UIImageView* backgroundHeaderImage;
@property (nonatomic, strong) UIView* navBar;
@property (nonatomic, strong) FRHeaderQuestionairView* headerView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* headerCornerImage;

@end

static CGFloat const kHeaderTopOffset = 15;


@implementation FRRecommendedUserHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
//        [self backgroundHeaderImage];
//     //   self.backButton.layer.zPosition += 10;
//        [self headerView];
//        [self titleLabel];
//        [self headerCornerImage];
////        @weakify(self);
////        [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
////            @strongify(self);
////            [self.delegate backSelected];
////        }];
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        [self backButton];
//
////        [self.contentView bringSubviewToFront:self.backButton];

        [self titleLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)updateTitleFrameWithOffset:(CGPoint)point
{
    CGRect frame = self.titleLabel.frame;
    
    if (point.y > 130)
    {
        frame.origin.x = 50;
    }
    else
    {
        frame.origin.x = 20;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.frame = frame;
    }];
}

- (UIImageView*)backgroundHeaderImage
{
    if (!_backgroundHeaderImage)
    {
        _backgroundHeaderImage = [UIImageView new];
        _backgroundHeaderImage.userInteractionEnabled = YES;
        _backgroundHeaderImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundHeaderImage.image = [UIImage imageNamed:@"questionair-2"];
        [self.contentView addSubview:_backgroundHeaderImage];
        
        [_backgroundHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.headerView);
            make.height.equalTo(@130);

        }];
    }
    return _backgroundHeaderImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        
        _titleLabel = [UILabel new];
        
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _titleLabel.text = FRLocalizedString(@"RECOMMENDED USERS", nil);
        
        _titleLabel.frame = CGRectMake(20, 150, 150, 14);
        
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        
    }
    return _titleLabel;
}


//- (UIView*)navBar
//{
//    if (!_navBar)
//    {
//        _navBar = [UIView new];
//        [self addSubview:_navBar];
//        
//        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self.contentView);
//            make.height.equalTo(@64);
//        }];
//    }
//    return _navBar;
//}


- (FRHeaderQuestionairView*)headerView
{
    if (!_headerView)
    {
        _headerView = [[FRHeaderQuestionairView alloc]initWithTitle:FRLocalizedString(@"", nil) subtitle:FRLocalizedString(@"Here are some nearby users we \nthink you'll hit it off with", nil)];
        [self.contentView addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(-kHeaderTopOffset + 64);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@(111 + kHeaderTopOffset));
        }];
    }
    return _headerView;
}

//- (UIButton*)backButton
//{
//    if (!_backButton)
//    {
//        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 30, 30)];
//        _backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//        _backButton.layer.cornerRadius = 15;
//        _backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//        [_backButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
//        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
//        
//        [_backButton setImage:image forState:UIControlStateHighlighted];
//        _backButton.tintColor = [UIColor whiteColor];
//        [self.contentView addSubview:_backButton];
//    }
//    
//    return _backButton;
//}

-(UIImageView*)headerCornerImage
{
    if (!_headerCornerImage)
    {
        _headerCornerImage = [UIImageView new];
        [_headerCornerImage setImage:[FRStyleKit imageOfGroup4Canvas2]];
        [self addSubview:_headerCornerImage];
        [self.backgroundHeaderImage bringSubviewToFront:_headerCornerImage];
        [_headerCornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@10);
        }];
    }
    return _headerCornerImage;
}

@end
