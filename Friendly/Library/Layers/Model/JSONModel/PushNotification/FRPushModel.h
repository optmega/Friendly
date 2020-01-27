//
//  FRPushModel.h
//  Friendly
//
//  Created by Dmitry on 29.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRPushApsModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* alert;
@property (nonatomic, strong) NSString<Optional>* badge;

@end

@protocol FRPushApsModel <NSObject>
@end

@interface FRPushModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* room_id;
@property (nonatomic, strong) NSString<Optional>* event_id;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* notification_type;
@property (nonatomic, strong) FRPushApsModel<Optional>* aps;

@end
