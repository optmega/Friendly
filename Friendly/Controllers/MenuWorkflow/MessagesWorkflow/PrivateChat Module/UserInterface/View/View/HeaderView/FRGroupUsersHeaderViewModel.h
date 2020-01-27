//
//  FRGroupUsersHeaderViewModel.h
//  Friendly
//
//  Created by Sergey on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@protocol FRGroupUsersHeaderViewModelDelegate <NSObject>

- (void)selectedUsersId:(NSString*)userId;

@end

@interface FRGroupUsersHeaderViewModel : NSObject

@property (nonatomic, weak) id<FRGroupUsersHeaderViewModelDelegate> delegate;
@property (nonatomic, strong) NSDate* dateJoined;
@property (nonatomic, strong) NSArray* users;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, strong) MemberUser* cohost;
@property (nonatomic, strong) MemberUser* creator;

- (void)selectedUserId:(NSString*)userId;

@end
