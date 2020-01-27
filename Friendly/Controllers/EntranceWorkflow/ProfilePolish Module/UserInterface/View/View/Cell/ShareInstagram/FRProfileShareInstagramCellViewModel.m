//
//  FRProfileShareInstagramCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileShareInstagramCellViewModel.h"
#import "FRUserManager.h"

@implementation FRProfileShareInstagramCellViewModel

- (void)connectSelected
{
    [self.delegate connectSelected];
}

- (CGFloat)heightCell
{
    if([FRUserManager sharedInstance].currentUser.images.count > 0)
    {
        self.isSelfInstagramConnected = YES;
        return 220;
    }
    
    if (([self.instagram_media_count isEqualToString:@"0"])&&(self.instagram_username!=nil))
    {
        return 80;
    }
    
    return 100;
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.delegate showPreviewWithImage:image];
}

@end
