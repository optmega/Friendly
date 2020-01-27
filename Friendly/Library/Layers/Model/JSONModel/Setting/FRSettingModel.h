//
//  FRSettingModel.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRSettingModel : JSONModel


@property (nonatomic, assign) BOOL group_chat_messages;
@property (nonatomic, strong) NSString<Optional>*  first_name;
@property (nonatomic, assign) BOOL event_invites;
@property (nonatomic, assign) BOOL friend_requests;
@property (nonatomic, assign) BOOL event_requests;
@property (nonatomic, assign) BOOL private_account;

@end
