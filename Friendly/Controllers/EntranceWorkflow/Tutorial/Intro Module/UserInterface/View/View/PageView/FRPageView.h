//
//  FRPageView.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "EAIntroPage.h"
#import "FRBasePageView.h"

@interface FRPageView : EAIntroPage

@property (nonatomic, strong) FRBasePageView* customPageView;

- (instancetype)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle;

@end
