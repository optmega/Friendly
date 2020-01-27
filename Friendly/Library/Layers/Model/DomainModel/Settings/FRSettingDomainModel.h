//
//  FRSettitngDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 13.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"

@interface FRSettingDomainModel : FRBaseDomainModel

@property (nonatomic, assign) BOOL group_chat_messages;
@property (nonatomic, assign) BOOL event_invites;
@property (nonatomic, assign) BOOL friend_requests;
@property (nonatomic, assign) BOOL event_requests;
//@property (nonatomic, strong) NSString* user_name;
@property (nonatomic, assign) BOOL private_account;

@end

