//
//  FRSplashVC.m
//  Friendly
//
//  Created by Sergey Borichev on 10.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSplashVC.h"
#import "UIImage+GIF.h"
#import "FRStyleKit.h"

@interface FRSplashVC ()

@property (nonatomic, strong) UIImageView* appNameImage;
@property (nonatomic, strong) UIImageView* logoImage;
@end

@implementation FRSplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self appNameImage];
    [self logoImage];
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstVisit"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"FirstVisit"];
        self.logoImage.hidden = false;
        self.appNameImage.hidden = true;
//    } else {
//        self.view.backgroundColor = [UIColor bs_colorWithHexString:@"#E9ECF2"];
//        self.logoImage.hidden = true;
//        self.appNameImage.hidden = true;
//    }
}


#pragma mark - Lazy Load

- (UIImageView*)logoImage
{
    if (!_logoImage)
    {
        _logoImage = [UIImageView new];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.backgroundColor = [UIColor clearColor];
        _logoImage.hidden = true;
        //self.logoImage.image =  [UIImage sd_animatedGIFNamed:@"loader"];// [UIImage imageNamed:@"intro-loop.gif"];
        self.logoImage.image = [UIImage imageNamed:@"Loading screen"];
//        self.logoImage.image = [FRStyleKit imageOfSplashLogoNew];
        [self.view addSubview:_logoImage];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.appNameImage.mas_top).offset(-20);
//            make.centerX.equalTo(self.view);
//            make.height.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.edges.equalTo(self.view);
        }];
    }
    return _logoImage;
}
//Page
- (UIImageView*)appNameImage
{
    if (!_appNameImage)
    {
        _appNameImage = [UIImageView new];
        _appNameImage.hidden = true;
        _appNameImage.contentMode = UIViewContentModeScaleAspectFit;
        _appNameImage.image = [FRStyleKit imageOfPage1Canvas2];
        
        [self.view addSubview:_appNameImage];
        
        [_appNameImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width / 3 - 30));
            make.top.equalTo(self.view.mas_centerY).offset(20);
        }];
    }
    return _appNameImage;
}


@end
