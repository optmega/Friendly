//
//  FRPhotoPickerController.m
//  Friendly
//
//  Created by Sergey Borichev on 29.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPhotoPickerController.h"
#import "FRUploadImage.h"
#import "UIImage+Resize.h"

@interface FRPhotoPickerController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation FRPhotoPickerController

- (instancetype)initWithViewController:(UIViewController*)viewController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.delegate = self;
    [viewController presentViewController:picker animated:YES completion:nil];
    return self;
}


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    CGFloat scale = 1;
    
    if (image.size.width < image.size.height)
    {
        scale = 1.4;
    }

   image = [image croppedImage:CGRectMake(0, 0, image.size.width, image.size.height / scale)];
    
    UIImage* newImage = [FRUploadImage image:image quality:self.quality];
    [self.delegate imageSelected:newImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.closeDelegate closeVC];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
