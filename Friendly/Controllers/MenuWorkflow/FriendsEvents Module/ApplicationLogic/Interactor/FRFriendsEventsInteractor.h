//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsInteractorIO.h"

@interface FRFriendsEventsInteractor : NSObject <FRFriendsEventsInteractorInput>

@property (nonatomic, weak) id<FRFriendsEventsInteractorOutput> output;

@end

