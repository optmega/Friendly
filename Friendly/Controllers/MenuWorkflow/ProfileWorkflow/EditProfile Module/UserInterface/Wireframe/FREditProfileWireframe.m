//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileWireframe.h"
#import "FREditProfileInteractor.h"
#import "FREditProfileVC.h"
#import "FREditProfilePresenter.h"
#import "FRSettingWireframe.h"
#import "FRPhotoPickerController.h"


@interface FREditProfileWireframe ()<FRPhotoPickerControllerDelegate>

@property (nonatomic, weak) FREditProfilePresenter* presenter;
@property (nonatomic, weak) FREditProfileVC* editProfileController;
@property (nonatomic, weak) UINavigationController* presentedController;
@property (nonatomic, assign) FRChangePhotoType changePhotoType;
@property (nonatomic, strong) FRPhotoPickerController* pickerController;

@end

@implementation FREditProfileWireframe

- (void)presentEditProfileControllerFromNavigationController:(UINavigationController*)nc userModel:(UserEntity*)userModel
{
    FREditProfileVC* editProfileController = [FREditProfileVC new];
    FREditProfileInteractor* interactor = [FREditProfileInteractor new];
    FREditProfilePresenter* presenter = [FREditProfilePresenter new];
    
    interactor.output = presenter;
    
    editProfileController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:editProfileController userModel:userModel];
    
    BSDispatchBlockToMainQueue(^{
//        [nc pushViewController:editProfileController animated:NO];
        [nc presentViewController:editProfileController animated:false completion:nil];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.editProfileController = editProfileController;
}

- (void)presentSettingController
{
    [[FRSettingWireframe new] presentSettingControllerFromController:self.editProfileController];
}

- (void)dismissEditProfileController
{
//    [self.presentedController popViewControllerAnimated:NO];
    [self.editProfileController dismissViewControllerAnimated:false completion:nil];
}

- (void)presentPhotoPickerControllerWithType:(FRChangePhotoType)type
{
    self.changePhotoType = type;
    self.pickerController = [[FRPhotoPickerController alloc] initWithViewController:self.editProfileController];
    self.pickerController.quality = 0.6;
    self.pickerController.withScale = type == FRChangePhotoTypeWall;
    self.pickerController.delegate = self;
}


#pragma mark - FRPhotoPickerControllerDelegate

- (void)imageSelected:(UIImage*)image
{
    [self.presenter updatePhoto:image type:self.changePhotoType];
    
}



@end
