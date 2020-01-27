//
//  FRUpdateMessageStatusModel.h
//  Friendly
//
//  Created by Dmitry on 19.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"
#import "FRWebSocketConstants.h"

@interface FRUpdateMessageStatusModel : FRBaseDomainModel

@property (nonatomic, assign) FRWSMessageType type;
@property (nonatomic, assign) FRMessageStatus status;
@property (nonatomic, strong) NSString* messageId;

@end


