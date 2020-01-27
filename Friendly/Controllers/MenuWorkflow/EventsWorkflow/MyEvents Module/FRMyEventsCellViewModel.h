//
//  FRMyEventsCellViewModel.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventModel.h"
#import "FREvent.h"

typedef NS_ENUM(NSInteger, FRMyEventsCellType)
{
    FRMyEventsCellTypeHosting,
    FRMyEventsCellTypeJoining,
};

@interface FRMyEventsCellViewModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model type:(FRMyEventsCellType)type;

@property (strong, nonatomic) FREvent* eventModel;
@property (assign, nonatomic) FRMyEventsCellType type;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* backImage;
@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) NSString* event_type;
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* distance;

@end
