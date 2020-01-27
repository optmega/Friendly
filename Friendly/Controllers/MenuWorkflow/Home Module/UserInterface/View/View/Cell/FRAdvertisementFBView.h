//
//  FRAdvertisementFBView.h
//  Friendly
//
//  Created by Sergey on 25.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBMediaView, FBAdChoicesView, FBNativeAd;

@interface FRAdvertisementFBView : UIView {
    FBAdChoicesView *adChoicesView;
}

@property (weak, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (weak, nonatomic) IBOutlet UILabel *adSocialContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsoredLabel;

@property (weak, nonatomic) IBOutlet FBMediaView *adCoverMediaView;

@property (weak, nonatomic) IBOutlet UIView *adView;

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd;

@end
