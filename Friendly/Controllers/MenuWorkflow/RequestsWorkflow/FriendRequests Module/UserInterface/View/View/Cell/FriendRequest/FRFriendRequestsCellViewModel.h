//
//  FRFriendRequestsCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@class FRUserModel, FRFriendlyRequestModel, FRFriendRequestsCellViewModel;


@protocol FRFriendRequestsCellViewModelDelegate <NSObject>

- (void)selectedAccept:(FRFriendRequestsCellViewModel*)model;
- (void)selectedDecline:(FRFriendRequestsCellViewModel*)model;
- (void)showUserProfileWithUserId:(NSString*)userId;

@end

@interface FRFriendRequestsCellViewModel : NSObject

+ (instancetype)initWithModel:(FRFriendlyRequestModel*)model;

@property (nonatomic, weak) id<FRFriendRequestsCellViewModelDelegate> delegate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, assign) BOOL isBusy;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* requestId;

- (void)updatePhotoImage:(UIImageView*)image;

- (void)selectedAccept;
- (void)selectedDecline;
- (void)showUserProfileWithEntity:(UserEntity*)user;

@end
