//
//  FRLetsGoContentView.h
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRLetsGoContentView : UIView

@property (nonatomic, strong) UIButton* letsGoButton;
@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, strong) UILabel* smileLabel;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIImageView* backgroundImage;
@property (nonatomic, strong) UILabel* smile;
@property (nonatomic, strong) MASConstraint* heightConstraint;

@end
