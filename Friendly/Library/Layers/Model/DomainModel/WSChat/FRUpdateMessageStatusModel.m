//
//  FRUpdateMessageStatusModel.m
//  Friendly
//
//  Created by Sergey on 19.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUpdateMessageStatusModel.h"

@implementation FRUpdateMessageStatusModel


- (NSDictionary*)domainModelDictionary
{
    NSDictionary* data = @{@"msg_status" : @(self.status),
                           @"msg_id" : self.messageId
                           };
    
    return @{@"msg_type" : @(self.type),
             @"data" : data};
    
}

@end

