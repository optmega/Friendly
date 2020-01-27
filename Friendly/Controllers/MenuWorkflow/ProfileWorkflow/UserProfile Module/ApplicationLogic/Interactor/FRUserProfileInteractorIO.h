//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserModel;

typedef NS_ENUM(NSInteger, FRUserProfileHudType) {
    FRUserProfileHudTypeError,
    FRUserProfileHudTypeShowHud,
    FRUserProfileHudTypeHideHud,
};

@protocol FRUserProfileInteractorInput <NSObject>

- (void)loadDataWithUser:(UserEntity*)user;
- (void)blockUserWithId:(NSString*)userId;
- (void)reportUserWithId:(NSString*)userId;
- (void)removeUserWithId:(NSString*)userId;
- (void)updateData;
@property (nonatomic, strong) UserEntity* user;


@end


@protocol FRUserProfileInteractorOutput <NSObject>

- (void)dataLoadedWithUserModel:(UserEntity*)user mutual:(NSArray*)mutual;
- (void)showHudWithType:(FRUserProfileHudType)type title:(NSString*)title message:(NSString*)message;
- (void)backSelected;
- (void)updateData;

@end