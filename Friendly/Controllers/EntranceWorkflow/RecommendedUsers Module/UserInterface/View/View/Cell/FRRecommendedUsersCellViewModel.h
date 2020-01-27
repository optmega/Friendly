//
//  FRRecommendedUsersCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRUserModel, FRRecommendedUsersCellViewModel;

@protocol FRRecommendedUsersCellViewModelDelegate <NSObject>

- (void)addUser:(FRRecommendedUsersCellViewModel*)userModel;
- (void)showUserProfile:(NSString*)userId;

@end

@interface FRRecommendedUsersCellViewModel : NSObject

@property (nonatomic, weak) id<FRRecommendedUsersCellViewModelDelegate> delegate;
@property (nonatomic, assign) BOOL isRequstedMode;

+ (instancetype)initWithModel:(FRUserModel*)model;

- (void)showUserProfile;
- (void)addUser;
- (NSString*)username;
- (NSString*)userId;
- (NSString*)usersInterests;

- (void)updateUserPhoto:(UIImageView*)imageView;

- (FRUserModel*)domainModel;

@end
