//
//  FReventPreviewCategoryCellViewModel.h
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FREventModel.h"
#import "FREvent.h"

@interface FREventPreviewCategoryCellViewModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model;

@property (strong, nonatomic) NSString* category;

@end
