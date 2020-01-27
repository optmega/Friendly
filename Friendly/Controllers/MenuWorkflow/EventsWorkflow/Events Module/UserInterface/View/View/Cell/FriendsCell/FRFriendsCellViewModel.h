//
//  FRFriendsCellViewModel.h
//  Friendly
//
//  Created by Jane Doe on 4/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FRFriendsCellViewModelDelegate <NSObject>

//- (void)pressUserPhoto:(NSString*)userId;

@end

@interface FRFriendsCellViewModel : NSObject

@property (nonatomic, weak) id<FRFriendsCellViewModelDelegate>delegate;
@property (nonatomic, strong) NSArray* list;

@end
