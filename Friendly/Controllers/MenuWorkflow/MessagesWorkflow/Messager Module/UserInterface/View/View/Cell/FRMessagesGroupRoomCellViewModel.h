//
//  FRMessagesGroupRoomCellViewModel.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupRoom.h"


@protocol FRMessagesGroupRoomCellViewModelDelegate <NSObject>

- (void)selectedGroupRoom:(FRGroupRoom*)groupRoom;

@end

@interface FRMessagesGroupRoomCellViewModel : NSObject

@property (nonatomic, weak) id<FRMessagesGroupRoomCellViewModelDelegate> delegate;
@property (nonatomic, strong) NSString* dayOfWeak;
@property (nonatomic, strong) NSString* dayOfMonth;
@property (nonatomic, strong) NSString* name;


+ (instancetype)initWithModel:(FRGroupRoom*)model;

- (void)updateUserImages:(NSArray*)images;
- (FRGroupRoom*)domainModel;
- (void)selectedGroupRoom;
- (void)setLastMessageUserImage:(UIImageView*)imageView;

- (BOOL)isNewMessage;
- (NSString*)lastMessage;
- (NSString*)date;

@end
