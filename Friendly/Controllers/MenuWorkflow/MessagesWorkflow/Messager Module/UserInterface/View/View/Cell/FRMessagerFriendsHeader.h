//
//  FRMessagerFriendsHeader.h
//  Friendly
//
//  Created by Dmitry on 16.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRMessagerFriendsHeaderDelegate <NSObject>

- (void)showAddUsers;
- (void)selectedUser:(UserEntity*)user;
- (id)objectForIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)countObject;
- (void)updateAvailableFriends;

@end

@interface FRMessagerFriendsHeader : UIView

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, weak) id<FRMessagerFriendsHeaderDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
- (void)updateWithFriends:(NSArray*)friends;
- (void)addMode;

@end
