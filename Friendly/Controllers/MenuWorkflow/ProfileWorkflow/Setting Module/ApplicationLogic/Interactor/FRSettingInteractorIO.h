//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRSettingModel, FRSettingDomainModel;

typedef NS_ENUM(NSInteger, FRSettingHudType) {
    FRSettingHudTypeError,
    FRSettingHudTypeShowHud,
    FRSettingHudTypeHideHud,
};

@protocol FRSettingInteractorInput <NSObject>

- (void)saveSetting:(FRSettingDomainModel*)domainModel;
- (void)loadData;
- (void)logOut;
@end


@protocol FRSettingInteractorOutput <NSObject>

- (void)dataLoaded:(Setting*)model;
- (void)showHudWithType:(FRSettingHudType)type title:(NSString*)title message:(NSString*)message;
- (void)logOuted;

@end