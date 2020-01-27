//
//  FRPhotosMutualFriendCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPhotosMutualFriendCellViewModel.h"
#import "FREventModel.h"
#import "FRFriendsTransport.h"


@interface FRPhotosMutualFriendCellViewModel ()

@property (nonatomic, strong) NSArray* friends;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FRPhotosMutualFriendCellViewModel




- (NSArray*)friends {
    
    
    if (!self.isMyProfile) {
        return self.users;
    }
    
    if (!_friends) {
        NSArray* array = [[[FRUserManager sharedInstance].currentUser friends] allObjects];
        
        _friends = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:true]]];

    }
    
    return _friends;
}

- (void)loadFriendsForNextPage {
    
    if (self.isMyProfile) {
        
        NSInteger page = self.friends.count / 10 + 1;
        
        if (page > self.page) {
            
            self.page = page;
            [FRFriendsTransport getMyFriendsListPage:page success:^(FRFriendsListModel *friendsList) {
                
                NSArray* array = [[[FRUserManager sharedInstance].currentUser friends] allObjects];
                _friends = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:true]]];
                
                [self.collectionView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    
    
}

- (NSString*)title
{
    NSArray* users = self.users;
    if (self.users.count == 0)
    {
        return @"0 Mutual Friends";
    }
    else
    {
    return [NSString stringWithFormat:@"%lu Mutual Friend%@", (unsigned long)users.count, users.count == 1 ? @"" : @"s"];
    }
//    return @"0 Mutual Friends";
}

- (void) showUserProfile:(NSString *)userId
{
    [self.delegate showUserProfile:userId];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.delegate showUserProfileWithEntity:user];
}

-(CGFloat)height
{
    if (self.users.count == 0)
    {
        return 0;
    }
    else
    {
        return 220;
    }
}



@end
