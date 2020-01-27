//
//  FRMessage+Create.h
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRPrivatChatResponseModel, FRPrivateJSONMessage;

#import "FRPrivateMessage.h"

@interface FRPrivateMessage (Create)

- (void)updatePriveteMessage:(FRPrivatChatResponseModel*)model;
- (void)updateLastMessage:(FRPrivateJSONMessage*)model;
+ (FRPrivateMessage*)createWithModel:(FRPrivateJSONMessage*)model inContext:(NSManagedObjectContext*)context;


@end
