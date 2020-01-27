//
//  FRPhotoPickerController.h
//  Friendly
//
//  Created by Sergey Borichev on 29.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRPhotoPickerControllerDelegate <NSObject>

- (void)imageSelected:(UIImage*)image;

@end

@protocol FRPhotoPickerControllerCloseDelegate <NSObject>

-(void)closeVC;

@end

@interface FRPhotoPickerController : NSObject

@property (nonatomic, weak) id<FRPhotoPickerControllerDelegate> delegate;
@property (nonatomic, assign) double quality;
@property (nonatomic, assign) BOOL withScale;
@property (weak, nonatomic) id<FRPhotoPickerControllerCloseDelegate> closeDelegate;

- (instancetype)initWithViewController:(UIViewController*)viewController;

@end
