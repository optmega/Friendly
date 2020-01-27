//
//  UITabBarItem+CustomBadge.m
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"


#define CUSTOM_BADGE_TAG 99
#define OFFSET 0.6f
#define heightConstr 18.0f

@implementation UITabBarItem (CustomBadge)


-(void) setMyAppCustomBadgeValue: (NSString *) value
{
    
    UIFont *myAppFont = [UIFont systemFontOfSize:20.0];
    UIColor *myAppFontColor = [UIColor whiteColor];
    UIColor *myAppBackColor = [UIColor lightGrayColor];
    
    [self setCustomBadgeValue:value withFont:myAppFont andFontColor:myAppFontColor andBackgroundColor:myAppBackColor];
}



-(void) setCustomBadgeValue: (NSString *) value withFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor
{
    UIView *v = (UIView *)[self performSelector:@selector(view)];
    
    [self setBadgeValue:value];
    
    for(UIView *sv in v.subviews)
    {
        
        NSString *str = NSStringFromClass([sv class]);
        
        if([str isEqualToString:@"_UIBadgeView"])
        {
            
            for (UIView *ssv in sv.superview.subviews)
            {
                NSString *str = NSStringFromClass([ssv class]);

                if([str isEqualToString:@"UITabBarSwappableImageView"])
                {
                    for(UIView *sssv in ssv.subviews)
                    {
                        if(sssv.tag == CUSTOM_BADGE_TAG) { [sssv removeFromSuperview]; }
                    }
                    sv.hidden = YES;
                    
                    if (!value.integerValue) return;
                    UIButton* button = [self badgeButtonOnView:ssv withContent:value];
                    button.tag = CUSTOM_BADGE_TAG;
                }
                
            }
        }
    }
}


- (UIButton*)badgeButtonOnView:(UIView*)superView withContent:(NSString*) value
{
    UIButton* _badgeButton = [UIButton new];
    _badgeButton = [UIButton new];

    [_badgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _badgeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _badgeButton.layer.cornerRadius = heightConstr / 2;
    [_badgeButton setBackgroundColor:[UIColor bs_colorWithHexString:@"FE0000"]];
    _badgeButton.tag = CUSTOM_BADGE_TAG;

    NSString* count = @"";
    
    if (value.integerValue < 10) {
        count = [NSString stringWithFormat:@" %@ ", value];
    } else if ( value.integerValue >= 10 && value.integerValue < 100) {
        count = [NSString stringWithFormat:@"  %@  ", value];
    } else if ( value.integerValue >= 100) {
        count = @" >99 ";
    }
    
    [_badgeButton setTitle:count forState:UIControlStateNormal];
    [_badgeButton.titleLabel sizeToFit];
    CGFloat width = _badgeButton.titleLabel.bounds.size.width < 19 ? 19 : _badgeButton.titleLabel.bounds.size.width;

    
    
    CGFloat offsetForBack = 3;
    
    UIView* back = [UIView new];
    back.layer.cornerRadius = (heightConstr + offsetForBack) / 2;
    back.backgroundColor = [UIColor whiteColor];
    back.tag = CUSTOM_BADGE_TAG;
    [superView addSubview:back];
    
    
    [superView addSubview:_badgeButton];

    [_badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heightConstr));
        make.width.equalTo(@(width));
        make.top.equalTo(superView.superview).offset(6);
        make.right.equalTo(superView.superview).offset(-6);
    }];
    
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heightConstr + offsetForBack));
        make.width.equalTo(@(width + offsetForBack));
        make.center.equalTo(_badgeButton);
    }];
    

    return _badgeButton;
}



@end
