//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileInteractorIO.h"
#import "FREditProfileWireframe.h"
#import "FREditProfileViewInterface.h"
#import "FREditProfileModuleDelegate.h"
#import "FREditProfileModuleInterface.h"

@class FRUserModel;

@interface FREditProfilePresenter : NSObject <FREditProfileInteractorOutput, FREditProfileModuleInterface>

@property (nonatomic, strong) id<FREditProfileInteractorInput> interactor;
@property (nonatomic, strong) FREditProfileWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FREditProfileViewInterface>* userInterface;
@property (nonatomic, weak) id<FREditProfileModuleDelegate> editProfileModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FREditProfileViewInterface>*)userInterface userModel:(UserEntity*)userModel;
- (void)updatePhoto:(UIImage*)photo type:(FRChangePhotoType)type;

@end
