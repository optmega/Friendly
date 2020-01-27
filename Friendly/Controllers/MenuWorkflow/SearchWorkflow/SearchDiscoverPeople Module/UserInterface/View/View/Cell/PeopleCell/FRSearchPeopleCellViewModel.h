//
//  FRSearchPeopleCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRSearchUserModel;

@protocol FRSearchPeopleCellViewModelDelegate <NSObject>

- (void)profileSelectedWithUserId:(NSString*)userId;
- (void)addSelectedWithUserId:(NSString*)userId;
- (void)friendsSelectedWithUserId:(NSString*)userId;

@end

@interface FRSearchPeopleCellViewModel : NSObject

@property (nonatomic, assign) NSInteger isFriend;
@property (nonatomic, strong) NSArray* instagramPhotos;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* away;
@property (nonatomic, strong) NSAttributedString* commonFriendsOrTag;
@property (nonatomic, weak) id<FRSearchPeopleCellViewModelDelegate>delegate;


+ (instancetype)initWithModel:(FRSearchUserModel*)model;

- (void)updateUserPhoto:(UIImageView*)userPhoto;


- (void)profileSelected;
- (void)addSelected;
- (void)friendsSelected;


@end


