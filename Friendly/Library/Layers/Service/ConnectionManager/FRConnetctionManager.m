//
//  FRConnetctionManager.m
//  Friendly
//
//  Created by Sergey on 04.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRConnetctionManager.h"
#import "FRStyleKit.h"
#import "FRNetworkManager.h"
@interface FRConnetctionManager ()

@property (nonatomic, assign) AFNetworkReachabilityStatus connectionStatus;
@property (nonatomic, strong) FRConnetctionView* connectionView;

@end

@implementation FRConnetctionManager

+ (instancetype)shared {
    
    static FRConnetctionManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FRConnetctionManager new];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
        
        self.connectionView = [[FRConnetctionView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 35)];
        
        [[[FRNetworkManager shared] networkReachabilityStatusSignal] subscribeNext:^(id x) {
            
            AFNetworkReachabilityStatus status = [x integerValue];
            
            self.connectionStatus = status;
            [self updateConnectionViewStatus:status];
        }];
    }
    
    return self;
}

- (void)updateConnectionViewStatus:(AFNetworkReachabilityStatus) status {
    
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            [self.connectionView removeFromSuperview];
            break;
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusUnknown:

             [[UIApplication sharedApplication].keyWindow addSubview:self.connectionView];
    }
}
    


+ (BOOL)isConnected {
    return [[self shared] connectionStatus] == AFNetworkReachabilityStatusReachableViaWWAN ||
            [[self shared] connectionStatus] == AFNetworkReachabilityStatusReachableViaWiFi;
}


@end

@interface FRConnetctionView ()

@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIButton* close;

@end

@implementation FRConnetctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor bs_colorWithHexString:@"1C163C"] colorWithAlphaComponent:0.95];
        [self contentLabel];
        [[self.close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self removeFromSuperview];
        }];
    }
    return self;
}

- (UIButton*)close {
    if (!_close) {
        _close = [UIButton new];
        [_close setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        
        [self addSubview:_close];
        [_close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-8);
            make.centerY.equalTo(self);
        }];
    }
    return  _close;
}

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"Your connection appears to be offline";
        _contentLabel.font = FONT_SF_TEXT_REGULAR(14);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.adjustsFontSizeToFitWidth = true;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
        }];
    }
    return _contentLabel;
}

- (void)dealloc {
    
}
@end
