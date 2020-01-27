//
//  FREventsRequests.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRUserModel.h"


typedef NS_ENUM(NSInteger, FREventRequestsStatusType) {
    FREventRequestsStatusPanding,
    FREventRequestsStatusAccepted,
    FREventRequestsStatusDeclined,
};


@interface FREventsRequest : JSONModel

@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* event_id;
@property (nonatomic, assign) FREventRequestsStatusType system_status;
@property (nonatomic, strong) FRUserModel<Optional>* user;
@property (nonatomic, strong) NSString<Optional>* date_added;
@property (nonatomic, strong) NSString<Optional>* id;


@end


@protocol FREventsRequest <NSObject>
@end


//@interface FREventsRequests : JSONModel
//
//@property (nonatomic, strong) NSArray<Optional, FREventsRequest*>* requests;
//
//@end
