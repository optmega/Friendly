//
//  FRConnetctionManager.h
//  Friendly
//
//  Created by Sergey on 04.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"

@interface FRConnetctionManager : NSObject

+ (instancetype)shared;

+ (BOOL)isConnected;

@end


@interface FRConnetctionView : UIView

//- (void)update
@end