//
//  FRCreateEventAgeCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventViewConstants.h"

typedef NS_ENUM(NSInteger, FRAgeCellType) {
    FRAgeCellTypeImage,
    FRAgeCellTypeLabel,
};

@interface FRCreateEventAgeCellViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* contentTitle;

@property (nonatomic, strong) NSArray* contentArray;

@property (nonatomic, assign) FRCreateEventCellType type;
@property (nonatomic, assign) FRAgeCellType cellType;
@property (nonatomic, assign) FRGenderType gender;
@property (nonatomic, assign) FRDateFilterType dateType;
@property (nonatomic, assign) BOOL isRequired;
@property (nonatomic, strong) NSString* categoryId;
@property (nonatomic, strong) NSString* lat;
@property (nonatomic, strong) NSString* lon;
@property (nonatomic, strong) NSString* place_name;
- (NSAttributedString*)attributedTitle;

@end
