//
//  FREventPreviewEventViewCellViewModel.h
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FREventModel.h"
#import "FREvent.h"
#import "MemberUser.h"

@protocol FREventPreviewEventViewCellViewModelDelegate <NSObject>

- (void)selectedClose;

@end

@interface FREventPreviewEventViewCellViewModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model;

@property (nonatomic, weak) id<FREventPreviewEventViewCellViewModelDelegate> delegate;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* creatorAvatar;
@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) UserEntity* creator;
@property (assign, nonatomic) NSInteger slots;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* backImage;
@property (strong, nonatomic) NSString* event_type;
@property (strong, nonatomic) NSString* request_status;
@property (strong, nonatomic) NSString* distance;
@property (strong, nonatomic) NSString* partner_hosting;
@property (strong, nonatomic) NSString* partner_is_accepted;
@property (strong, nonatomic) MemberUser* partner;
@property (strong, nonatomic) FREvent* event;

- (void)selectedClose;

@end
