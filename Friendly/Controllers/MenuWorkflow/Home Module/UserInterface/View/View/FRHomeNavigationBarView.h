//
//  FRHomeNavigationBarView.h
//  Friendly
//
//  Created by Dmitry on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRHomeNavigationBarView : UIView

@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;
//@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* title;
- (void)setColorAlpha:(CGFloat)alpha;

@end
