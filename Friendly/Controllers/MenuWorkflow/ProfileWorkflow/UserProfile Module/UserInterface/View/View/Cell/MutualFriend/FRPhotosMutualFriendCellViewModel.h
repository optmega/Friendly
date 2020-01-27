//
//  FRPhotosMutualFriendCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRPhotosMutualFriendCellViewModelDelegate <NSObject>

-(void)showUserProfile:(NSString*)userId;
-(void)showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FRPhotosMutualFriendCellViewModel : NSObject

@property (nonatomic, assign) BOOL isMyProfile;
@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) NSString* friendsTitle;
@property (assign, nonatomic) BOOL isMyProfileCell;
@property (nonatomic, weak) UICollectionView* collectionView;
- (NSString*)title;
//- (NSArray*)users;
-(void)showUserProfile:(NSString*)userId;
-(void)showUserProfileWithEntity:(UserEntity*)user;
@property (weak, nonatomic) id<FRPhotosMutualFriendCellViewModelDelegate> delegate;
-(CGFloat)height;

- (NSArray*)friends;

- (void)loadFriendsForNextPage;
@end
