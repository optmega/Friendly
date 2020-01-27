//
//  FREventRequestsInviteModel.h
//  Friendly
//
//  Created by Jane Doe on 4/7/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FREventRequestsInviteModel : NSObject

//+ (instancetype) initWithModel:(FREventModel*)model;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* age;
@property (strong, nonatomic) NSString* friendsSince;
@property (strong, nonatomic) NSString* slots;
@property (strong, nonatomic) NSString* eventDate;
@property (strong, nonatomic) NSString* eventTitle;
@property (strong, nonatomic) NSString* avatar;

@end
