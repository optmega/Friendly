//
//  FREventPreviewInfoCellViewModel.h
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FREvent.h"

typedef NS_ENUM(NSInteger, FRInfoCellViewModelType) {
    FRInfoCellViewModelTypeWhere,
    FRInfoCellViewModelTypeTime,
    FRInfoCellViewModelTypeHostsNumber,
    FRInfoCellViewModelTypeOpen,
};

@interface FREventPreviewInfoCellViewModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model type:(FRInfoCellViewModelType)type;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subtitle;
@property (strong, nonatomic) UIImage* icon;

@end
