//
//  FREventImageSelectPhotoPreviewController.h
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRGalleryModel.h"

@protocol FREventImageSelectPhotoPreviewControllerDelegate <NSObject>

-(void)selectedPhoto:(UIImage*)image with:(FRPictureModel*)model;

@end

@protocol FREventImageSelectPhotoPreviewControllerCloseDelegate <NSObject>

-(void)closeVC;

@end

@interface FREventImageSelectPhotoPreviewController : UIViewController

-(void)updateWithPhoto:(UIImage*)image andGallery:(NSArray*)gallery andModels:(NSArray*)models andIndex:(NSInteger)index;
@property (weak, nonatomic) id<FREventImageSelectPhotoPreviewControllerDelegate> delegate;
@property (weak, nonatomic) id<FREventImageSelectPhotoPreviewControllerCloseDelegate> closeDelegate;
@property (strong, nonatomic) UIButton* useImageButton;
@property (strong, nonatomic) UIButton* closeButton;
//@property (strong, nonatomic) UIImageView* previewView;
@property (strong, nonatomic) UIImage* backImage;
@property (strong, nonatomic) UIView* closeBackView;
@property (nonatomic, strong) FRPictureModel* model;

@end
