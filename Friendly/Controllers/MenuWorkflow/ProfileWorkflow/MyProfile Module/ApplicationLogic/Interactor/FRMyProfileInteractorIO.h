//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserModel;

typedef NS_ENUM(NSInteger, FRMyProfileHudType) {
    FRMyProfileHudTypeError,
    FRMyProfileHudTypeShowHud,
    FRMyProfileHudTypeHideHud,
};

@protocol FRMyProfileInteractorInput <NSObject>

- (void)loadData;
- (void)updateData;
- (void)changeStatus:(NSInteger)status;


@end


@protocol FRMyProfileInteractorOutput <NSObject>

- (void)dataLoadedWithModel:(CurrentUser*)userModel andUsers:(NSArray*)friends;
- (void)updateDataWithModel:(CurrentUser*)userModel;
- (void)showHudWithType:(FRMyProfileHudType)type title:(NSString*)title message:(NSString*)message;


@end