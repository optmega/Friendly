//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerDataSource.h"
#import "BSMemoryStorage.h"
#import "FRPrivateRoom.h"
#import "FRGroupRoom.h"
#import "FRMessagesPrivateRoomCellViewModel.h"
#import "FRMessagesGroupRoomCellViewModel.h"

@interface FRMessagerDataSource () <FRMessagesPrivateRoomCellViewModelDelegate, FRMessagesGroupRoomCellViewModelDelegate>

@end

@implementation FRMessagerDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage
{
    
}

- (NSArray*)chatsViewModelFromModels:(NSArray*)models
{
    NSMutableArray* viewModels = [NSMutableArray array];
    [models enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id viewModel = nil;
        if ([obj isKindOfClass:[FRPrivateRoom class]])
        {
            viewModel = [FRMessagesPrivateRoomCellViewModel initWithModel:obj];
            ((FRMessagesPrivateRoomCellViewModel*)viewModel).delegate = self;
        }
        else if ([obj isKindOfClass:[FRGroupRoom class]])
        {
            viewModel = [FRMessagesGroupRoomCellViewModel initWithModel:obj];
            ((FRMessagesGroupRoomCellViewModel*)viewModel).delegate = self;
        }
        
        if (viewModel) {
            [viewModels addObject:viewModel];
        }
    }];
    
    return viewModels;
}


#pragma mark - Private

#pragma mark - FRMessagesPrivateRoomCellViewModelDelegate, FRMessagesGroupRoomCellViewModelDelegate

- (void)selectedRoom:(FRPrivateRoom*)room {
    [self.delegate selectedChatForRoom:room];
}

- (void)selectedGroupRoom:(FRGroupRoom*)groupRoom {
    [self.delegate selectedGroupRoom:groupRoom];
}



@end
