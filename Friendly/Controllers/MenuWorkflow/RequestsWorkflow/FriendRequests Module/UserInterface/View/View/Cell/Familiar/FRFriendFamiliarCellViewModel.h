//
//  FRFriendFamiliarCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRUserModel, FRPotentialFriendModel, FRFriendFamiliarCellViewModel;


@protocol FRFriendFamiliarCellViewModelDelegate <NSObject>

- (void)selectedAdd:(FRFriendFamiliarCellViewModel*)model;
- (void)selectedRemove:(FRFriendFamiliarCellViewModel*)model;
- (void)showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FRFriendFamiliarCellViewModel : NSObject

+ (instancetype)initWithModel:(FRPotentialFriendModel*)model;

@property (nonatomic, weak) id<FRFriendFamiliarCellViewModelDelegate> delegate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, assign) BOOL isBusy;
@property (nonatomic, strong) NSString* userId;

- (void)updatePhotoImage:(UIImageView*)image;

- (void)selectedAdd;
- (void)selectedRemove;
- (void)showUserProfileWithEntity:(UserEntity*)user;

@end




