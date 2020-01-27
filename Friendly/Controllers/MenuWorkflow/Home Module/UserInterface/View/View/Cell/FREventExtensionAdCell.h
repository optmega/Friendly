//
//  FREventExtensionAdCell.h
//  Friendly
//
//  Created by Sergey on 12.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventsCell.h"
#import "FRAdvertisementFBView.h"

@interface FREventExtensionAdCell : FREventsCell

@property (nonatomic, strong) FRAdvertisementFBView* contentAdView;
@property (nonatomic, strong) UIView* ad;
@end
