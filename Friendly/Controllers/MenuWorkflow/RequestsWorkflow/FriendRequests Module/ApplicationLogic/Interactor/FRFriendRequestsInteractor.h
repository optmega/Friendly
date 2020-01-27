//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsInteractorIO.h"

@interface FRFriendRequestsInteractor : NSObject <FRFriendRequestsInteractorInput>

@property (nonatomic, weak) id<FRFriendRequestsInteractorOutput> output;

@end

