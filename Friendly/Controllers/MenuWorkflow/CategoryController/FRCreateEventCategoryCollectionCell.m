//
//  FRCreateEventCategoryCollectionCell.m
//  Friendly
//
//  Created by Jane Doe on 3/22/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventCategoryCollectionCell.h"

@interface FRCreateEventCategoryCollectionCell ()

@property (nonatomic, strong) UILongPressGestureRecognizer* longTap;

@end

@implementation FRCreateEventCategoryCollectionCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage)];
        self.longTap.cancelsTouchesInView = NO;
        [self.backgroundImageView setUserInteractionEnabled:YES];
        [self.backgroundImageView addGestureRecognizer:self.longTap];
        [self.icon setUserInteractionEnabled:NO];
        self.backgroundImageView.layer.cornerRadius = 10;
        self.backgroundImageView.clipsToBounds = YES;
        self.longTap.minimumPressDuration = 0.07;
        self.longTap.numberOfTouchesRequired = 1;
        [self icon];
        [self nameLabel];
    }
    return self;
}

-(void) zoomImage
{
    switch (self.longTap.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width*0.9, self.backgroundImageView.frame.size.height*0.9);
                self.backgroundImageView.center = self.backgroundImageView.superview.center;
            }];
        }
                  break;
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width/9*10, self.backgroundImageView.frame.size.height/9*10);
                self.backgroundImageView.center = self.backgroundImageView.superview.center;
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - LazyLoad

-(UIImageView*) backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [UIImageView new];
        [self.contentView addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return _backgroundImageView;
}

-(UIImageView*) icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.userInteractionEnabled = YES;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundImageView);
            make.top.equalTo(self.contentView.mas_centerY).offset(-70);
            make.width.height.equalTo(@100);
        }];
    }
    return _icon;
}

-(UILabel*) nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        _nameLabel.font = FONT_CUSTOM_BOLD_SIZE(30);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(2);
            make.centerX.equalTo(self.contentView);
        }];
        
    }
    return _nameLabel;
}

@end
