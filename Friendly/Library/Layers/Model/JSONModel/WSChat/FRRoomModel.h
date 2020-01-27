//
//  FRRoomModel.h
//  Friendly
//
//  Created by Dmitry on 03.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRRoomModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* user2_id;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* user1_id;
@property (nonatomic, assign) BOOL is_new;
@end

