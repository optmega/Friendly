//
//  FRWebSocketTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 17.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"

@interface FRWebSocketTransport : FRBaseDomainModel

+ (void)sendMessage:(NSString*)message;

@end
