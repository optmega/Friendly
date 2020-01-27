//
//  FRPushHeaderViewModel.h
//  Friendly
//
//  Created by Dmitry on 20.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRPushModel;

#import "FRPushNotificationConstants.h"


@interface FRPushHeaderViewModel : NSObject

+ (instancetype)initWithPushData:(FRPushModel*)pushData;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;

@property (nonatomic, strong) NSString* leftIconUrl;
@property (nonatomic, strong) NSString* rightIconUrl;


@property (nonatomic, assign) BOOL canShowAlert;
- (void)setLeftIconImage:(UIImageView*)imageView;
- (void)setRightIconImage:(UIImageView*)imageView;


@end
