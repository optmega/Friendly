//
//  FREvent+Create.h
//  Friendly
//
//  Created by Sergey on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREvent.h"
#import "FREventModel.h"

typedef NS_ENUM(NSInteger, FREventCategoryType) {
//    FREventCategoryTypeNearby = 1, //не используем
//    FREventCategoryTypeFriend = 2, //не используем
//    FREventCategoryTypeFeatured = 3, // не используем
    FREventCategoryTypeHosting = 4,
    FREventCategoryTypeAttending = 5,
    
    FREventCategoryTypeAnother = 0,
};

@interface FREvent (Create)

+ (instancetype)initWithEvent:(FREventModel*)event inContext:(NSManagedObjectContext*)context;

+ (instancetype)initWithEvent:(FREventModel*)event withType:(FREventCategoryType)type inContext:(NSManagedObjectContext*)context;
//+ (instancetype)initWithEvent:(FREventModel*)event withType:(FREventCategoryType)type;
//- (void)updateWithModel:(FREventModel*)event;

@end
