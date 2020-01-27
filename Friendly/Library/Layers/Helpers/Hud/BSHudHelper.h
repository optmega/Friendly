//
//  BSHudHelper.h
//  PrimeTel
//
//  Created by Sergey Borichev on 26.12.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, BSHudType) {
    BSHudTypeError,
    BSHudTypeShowHud,
    BSHudTypeHideHud,
};

@interface BSHudHelper : NSObject

+ (void)showHudWithType:(BSHudType)type view:(UIViewController*)vc title:(NSString*)title message:(NSString*)message;

@end


