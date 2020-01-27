//
//  FRCreateEventAddImageCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventAddImageCellViewModel.h"
#import "UIImageView+WebCache.h"
@implementation FRCreateEventAddImageCellViewModel

- (void)close
{
    [self.delegate selectedClose];
}

- (void)uploadPhoto
{
    [self.delegate selectedUploadPhoto];
}

- (void)save
{
    [self.delegate selectedSave];
}

- (void)updateImage:(UIImageView*)imageView
{
    if (!self.photoUrl || !self.photoUrl.length)
    {
        return;
    }
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:self.photoUrl]];
    
    [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       if (image)
       {
           imageView.image = image;
           self.photo = image;
       }
    }];
}


@end

