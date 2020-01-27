//
//  FRWebSocketTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 17.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRWebSocketTransport.h"
#import "FRWSPrivateRequestDomainModel.h"
#import "FRWebSoketManager.h"

@implementation FRWebSocketTransport


+ (void)sendMessage:(NSString*)message
{
    [[FRWebSoketManager shared] sendMessage:message];
}

@end
