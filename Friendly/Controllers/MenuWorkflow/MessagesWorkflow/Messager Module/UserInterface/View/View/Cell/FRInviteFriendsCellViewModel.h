//
//  FRInviteFriendsCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRInviteFriendsCellViewModelDelegate <NSObject>

- (void)inviteFriendsSelected;

@end

@interface FRInviteFriendsCellViewModel : NSObject

@property (nonatomic, weak) id<FRInviteFriendsCellViewModelDelegate> delegate;

- (void)inviteFriendsSelected;
@property (nonatomic, strong) NSString* name;

@end
