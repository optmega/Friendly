//
//  FRVCWithOpacity.h
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRVCWithOpacity : UIViewController

@property (assign, nonatomic) CGFloat heightFooter;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) MASConstraint* bottom;
@property (nonatomic, strong) UIView* emptyFieldView;

- (void) closeVC;

@end
