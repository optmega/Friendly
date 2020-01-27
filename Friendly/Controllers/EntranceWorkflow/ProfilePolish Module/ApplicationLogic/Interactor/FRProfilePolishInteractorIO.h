//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRProfileDomainModel;

typedef NS_ENUM(NSInteger, FRProfilePolishHudType) {
    FRProfilePolishHudTypeError,
    FRProfilePolishHudTypeShowHud,
    FRProfilePolishHudTypeHideHud,
};

@protocol FRProfilePolishInteractorInput <NSObject>

- (void)loadDataWithInterests:(NSArray*)interests;
- (void)updateUserProfile:(FRProfileDomainModel*)model;

@end


@protocol FRProfilePolishInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)showHudWithType:(FRProfilePolishHudType)type title:(NSString*)title message:(NSString*)message;
- (void)profileUpdated;

@end