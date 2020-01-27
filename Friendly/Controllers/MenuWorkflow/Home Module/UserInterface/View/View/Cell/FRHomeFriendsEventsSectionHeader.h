//
//  FRHomeFriendsEventsSectionHeader.h
//  Friendly
//
//  Created by Sergey on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRHomeFriendsEventsSectionHeaderDelegate <NSObject>

- (void)pressFriendsEvents;

@end

@interface FRHomeFriendsEventsSectionHeaderViewModel : NSObject

- (void)updateUsers:(NSArray*)images whiteView:(NSArray*)whiteView;
- (NSString*)title;

- (void)pressFriendsEvents;
- (NSArray*)users;
@property (nonatomic, weak) id<FRHomeFriendsEventsSectionHeaderDelegate> delegate;

@end



@interface FRHomeFriendsEventsSectionHeader : UITableViewHeaderFooterView


- (void)update:(FRHomeFriendsEventsSectionHeaderViewModel*)model;

@end
