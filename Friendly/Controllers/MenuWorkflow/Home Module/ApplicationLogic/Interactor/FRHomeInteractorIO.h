//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class UserEntity;

typedef NS_ENUM(NSInteger, FRHomeHudType) {
    FRHomeHudTypeError,
    FRHomeHudTypeShowHud,
    FRHomeHudTypeHideHud,
};

@protocol FRHomeInteractorInput <NSObject>

- (void)loadData;
- (void)updateOldEvent;
- (void)updateNewEvent;
- (void)selectedUserId:(NSString*)userId;
- (void)willApear;

@end


@protocol FRHomeInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)showHudWithType:(FRHomeHudType)type title:(NSString*)title message:(NSString*)message;
- (void)eventUpdated;
- (void)featuredLoaded:(NSArray*)eventEntitys;
- (void)userProfileLoaded:(UserEntity*)user;
@end
