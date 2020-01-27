//
//  FRUserProfileInstagramPhotosCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileInstagramPhotosCellViewModel.h"
#import "FRUserManager.h"

@implementation FRUserProfileInstagramPhotosCellViewModel


- (NSString*)title
{
    if (([self.instagram_media_count isEqualToString:@"0"])&&(self.instagram_username!=nil))
    {
        return [NSString stringWithFormat:@"User has no instagram photos"];
    }
    else
        return @"";
//    else
//    {
//           return [NSString stringWithFormat:@"%@ %@", self.instagram_media_count, FRLocalizedString(@"Instagram photos", nil)];
//    }
}

- (CGFloat)heightCell
{
//    if ([[FRUserManager sharedInstance] currentUser].instagram_id == nil) {
//        return 100;
//    }
//    
//    
//    CGFloat height = 100;
//    
//    if(([FRUserManager sharedInstance].userModel.instagram_id>0)&&(self.instagram_username!=nil))
//    {
//        self.isSelfInstagramConnected = YES;
//        height = 50;
//    }
//    if (self.instagram_media_count!=nil)
//    {
//        height += 170;
//    }
//    if (self.instagram_username==nil)
//    {
//        height = 0;
//    }
//        return height;
    if([FRUserManager sharedInstance].currentUser.instagramUsername != nil)
    {
        self.isSelfInstagramConnected = YES;
        if (([self.instagram_media_count isEqualToString:@"0"])&&(self.instagram_username!=nil))
        {
            return 60;
        }
        else if (self.instagram_username == nil)
        {
            return 0;
        }
        else
        {
            return 220;
        }
    }
    
    return 100;

}

- (void)connectInstagram
{
    [self.delegate connectInstagram];
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.delegate showPreviewWithImage:image];
}
@end
