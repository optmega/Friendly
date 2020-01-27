//
//  FRHomeEventTableHeaderView.h
//  Friendly
//
//  Created by Sergey on 04.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@class FREventsCellViewModel,FREvent ;

#import "FREventsCellViewModel.h"
#import "FREventCollectionCellFooter.h"


@interface FRHomeEventTableHeaderView : UIView

@property (weak, nonatomic) IBOutlet FREventCollectionCellFooter *footerView;

@property (weak, nonatomic) IBOutlet UILabel *featuredLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainUserPhoto;
@property (weak, nonatomic) IBOutlet UIButton* shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareButtonHeightConstr;

@property (weak, nonatomic) IBOutlet UIImageView* eventImage;
@property (nonatomic, weak) IBOutlet UIImageView* genderImage;

@property (nonatomic, strong) FREventsCellViewModel* viewModel;
@property (nonatomic, strong) FREvent* model;
@property (weak, nonatomic) IBOutlet UIImageView *partnerImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageCenterConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonConstr;

@property (nonatomic, strong) UIImageView* tempImage1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstr;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *overlayImage;
@property (nonatomic, strong) UIView* blackSeparator;

- (void)updateWithModel:(FREventsCellViewModel*)model;
- (void)updateAlpha:(CGFloat)alpha;

@end
