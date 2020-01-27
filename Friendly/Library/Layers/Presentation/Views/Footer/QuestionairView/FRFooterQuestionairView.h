//
//  FRFooterQuestionairView.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface FRFooterQuestionairView : UIView

- (instancetype)initWithCurrentPage:(NSInteger)page allPage:(NSInteger)allPage nextButtonTitle:(NSString*)title hideSkip:(BOOL)hideSkip;
@property (nonatomic, strong) UIButton* continueButton;
@property (nonatomic, strong) UIButton* skipButton;

@end
