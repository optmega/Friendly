//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRSearchUsers;

typedef NS_ENUM(NSInteger, FRSearchDiscoverPeopleHudType) {
    FRSearchDiscoverPeopleHudTypeError,
    FRSearchDiscoverPeopleHudTypeShowHud,
    FRSearchDiscoverPeopleHudTypeHideHud,
};

@protocol FRSearchDiscoverPeopleInteractorInput <NSObject>

- (void)loadData;
- (void)loadUsersForString:(NSString*)string;
@end


@protocol FRSearchDiscoverPeopleInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)usersLoaded:(FRSearchUsers*)users;
- (void)showHudWithType:(FRSearchDiscoverPeopleHudType)type title:(NSString*)title message:(NSString*)message;

@end