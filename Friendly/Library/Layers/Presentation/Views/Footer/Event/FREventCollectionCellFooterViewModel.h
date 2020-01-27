//
//  FREventCollectionCellFooterViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREvent;

@interface FREventCollectionCellFooterViewModel : NSObject

+ (instancetype)initWithModel:(FREvent*)eventModel;

@property (nonatomic, strong) NSArray* users;
@property (nonatomic, assign) NSInteger openSlots;
@property (nonatomic, strong) NSString* dayOfWeak;
@property (nonatomic, strong) NSString* dayOfMonth;

@end
