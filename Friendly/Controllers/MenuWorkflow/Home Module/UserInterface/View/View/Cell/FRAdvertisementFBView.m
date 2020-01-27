//
//  FRAdvertisementFBView.m
//  Friendly
//
//  Created by Sergey on 25.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAdvertisementFBView.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@implementation FRAdvertisementFBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.adIconImageView.layer.cornerRadius = 4;
    self.adIconImageView.clipsToBounds = true;
    self.adCallToActionButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
    self.adCallToActionButton.layer.cornerRadius = 5;
    self.adCallToActionButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);

}


- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    [self.adTitleLabel setText:nativeAd.title];
    [self.adBodyLabel setText:nativeAd.body];
    [self.adSocialContextLabel setText:nativeAd.socialContext];
    [self.adCallToActionButton setTitle:[NSString stringWithFormat:@" %@ ", nativeAd.callToAction]
                               forState:UIControlStateNormal];
    
//    [self.adCallToActionButton sizeToFit];
    
    [nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
        [self.adIconImageView setImage:image];
    }];
    
    [self.adCoverMediaView setNativeAd:nativeAd];
    
    // Add adChoicesView
    [adChoicesView removeFromSuperview];
    adChoicesView = [[FBAdChoicesView alloc] initWithNativeAd:nativeAd];
    [self.adView addSubview:adChoicesView];
    [adChoicesView updateFrameFromSuperview];
    
    
    [nativeAd registerViewForInteraction:self.adView withViewController:nil];
    
    [nativeAd registerViewForInteraction:self.adView withViewController:nil withClickableViews:@[self.adCallToActionButton, self.adCoverMediaView]];
    
    
    // Register the native ad view and its view controller with the native ad instance
//    [nativeAd registerViewForInteraction:self.adView withViewController:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [adChoicesView updateFrameFromSuperview];
    
}

@end
