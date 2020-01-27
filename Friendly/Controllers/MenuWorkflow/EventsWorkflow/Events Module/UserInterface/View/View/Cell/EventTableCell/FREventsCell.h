//
//  FREventCollectionCell.h
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREventModel, FRDistanceLabel;

#import "FREventCollectionCellFooter.h"
#import "BSTableViewCell.h"
#import "FREventsCellViewModel.h"

@interface FREventsCell : BSTableViewCell

@property (nonatomic, strong) UIImageView* eventImage;
@property (nonatomic, strong) UIImageView* userImage;
@property (nonatomic, strong) UIImageView* partnerAvatar;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) FRDistanceLabel* distanceLabel;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIImageView* genderImage;
@property (nonatomic, strong) UIButton* eventTypeButton;
@property (nonatomic, strong) FREventCollectionCellFooter* footerView;
@property (nonatomic, strong) UIView* contentForEvent;

@property (nonatomic, strong) UIView* partnerBorederWidth;

@end


