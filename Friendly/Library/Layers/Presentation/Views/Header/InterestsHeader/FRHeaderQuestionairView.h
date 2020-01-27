//
//  FRHeaderQuestionairView.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRHeaderQuestionairView : UIView

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle;
- (void)updateTitle:(NSString*)title subtitle:(NSString*)subtitle;

@end
