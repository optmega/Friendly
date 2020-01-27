//
//  FRIntroContentView.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRPageView;

@protocol FRIntroContentViewDelegate <NSObject>

- (void)scrollViewPositionX:(CGFloat)positionX;

@end

@interface FRIntroContentView : UIView

@property (nonatomic, weak) id <FRIntroContentViewDelegate> delegate;
@property (nonatomic, strong) UIButton* loginButton;

@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* fadeView;

@property (nonatomic, strong) FRPageView* page1;
@property (nonatomic, strong) FRPageView* page2;
@property (nonatomic, strong) FRPageView* page3;
@property (nonatomic, strong) FRPageView* page4;

- (void)closePrivacy;

@end
