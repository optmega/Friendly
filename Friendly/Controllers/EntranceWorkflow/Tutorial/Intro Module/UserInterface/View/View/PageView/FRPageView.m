//
//  FRPageView.m
//  Friendly
//
//  Created by Sergey Borichev on 28.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPageView.h"

@implementation FRPageView

- (instancetype)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle
{
    self = [[FRPageView alloc]init];
    self.bgImage = [UIImage imageNamed:@"Login-flow-bg-1"];
    self.bgColor = [UIColor whiteColor];
    self.customPageView = [[FRBasePageView alloc] initWithTitle:title subTitle:subTitle];
    if ([[UIScreen mainScreen] bounds].size.height < 568.0f)
    {
        self.customPageView.subtitleLabel.hidden = YES;
    }
    return self;
}



@end
