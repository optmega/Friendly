//
//  FRCalendarManager.h
//  Friendly
//
//  Created by Dmitry on 14.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREventModel;

typedef void(^complition)();

@interface FRCalendarManager : NSObject

+ (instancetype)sharedInstance;
- (void)addEvent:(FREvent*)event fromController:(UIViewController*)vc complitionBlock:(complition)complit;
+ (void)updateCalendarFromVC:(UIViewController*)vc;

@end
