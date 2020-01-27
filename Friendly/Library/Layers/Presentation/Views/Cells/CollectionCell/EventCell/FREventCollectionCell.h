//
//  FREventCollectionCell.h
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventCollectionCellViewModel.h"

@class FREventModel, FRDistanceLabel;

@interface FREventCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* eventImage;
@property (nonatomic, strong) UIImageView* userImage;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) FRDistanceLabel* distanceLabel;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIImageView* genderImage;



- (void)updateViewModel:(FREventCollectionCellViewModel*)model;

@end
