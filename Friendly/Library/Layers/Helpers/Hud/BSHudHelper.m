//
//  BSHudHelper.m
//  PrimeTel
//
//  Created by Sergey Borichev on 26.12.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//

#import "BSHudHelper.h"
#import "MBProgressHUD.h"


@implementation BSHudHelper

+ (void)showHudWithType:(BSHudType)type view:(UIViewController*)vc title:(NSString*)title message:(NSString*)message
{
    switch (type)
    {
        case BSHudTypeError:
        {
            [MBProgressHUD hideHUDForView:vc.view animated:YES];
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:title
                                        message:message
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction: [UIAlertAction actionWithTitle:FRLocalizedString(@"common.ok", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil ]];
            [vc presentViewController:alert animated:YES completion:nil];
            
        } break;
            
        case BSHudTypeShowHud:
        {
            MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
            hud.labelText = FRLocalizedString(@"hud.lable-title.loading", nil);
        } break;
            
        case BSHudTypeHideHud:
        {
            [MBProgressHUD hideHUDForView:vc.view animated:YES];
        } break;
            
        default:
            break;
    }
    
}

@end
