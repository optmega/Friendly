//
//  FRGroupMessage+FRGroupMessage_Create.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupMessage.h"
#import "FRGroupChatResponsModel.h"
#import "FRPrivatChatResponseModel.h"

@interface FRGroupMessage (Create)

- (void)updateGroupMessage:(FRGroupChatResponseModel*)model;

+ (FRGroupMessage*)createWithModel:(FRPrivateJSONMessage*)model inContext:(NSManagedObjectContext*)context;


@end
