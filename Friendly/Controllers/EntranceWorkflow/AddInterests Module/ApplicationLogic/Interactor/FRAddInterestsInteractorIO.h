//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRInterestsModels, FRInterestsModel, FRRecomendedUserModels;

typedef NS_ENUM(NSInteger, FRAddInterestsHudType) {
    FRAddInterestsHudTypeError,
    FRAddInterestsHudTypeShowHud,
    FRAddInterestsHudTypeHideHud,
};

@protocol FRAddInterestsInteractorInput <NSObject>

- (void)loadData;
- (void)selectetInterest:(FRInterestsModel*)string;
- (void)selectedContinue;
- (void)addTag:(NSString*)tag;

@end


@protocol FRAddInterestsInteractorOutput <NSObject>

- (void)dataLoadedWithModel:(FRInterestsModels*)model;
- (void)showHudWithType:(FRAddInterestsHudType)type title:(NSString*)title message:(NSString*)message;
- (void)goNextWithInterests:(NSArray*)interests;
- (void)addedInterests:(FRInterestsModel*)interest;
- (void)goNextWithUsers:(FRRecomendedUserModels*)users interests:(NSArray*)interests;
- (void)goProfileSettingsWithInterests:(NSArray*)interests;

@end