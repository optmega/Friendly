//
//  FRCreateEventIconDataCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventViewConstants.h"


@interface FRCreateEventIconDataCellViewModel : NSObject

@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* dataString;
@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, assign) BOOL isInputViewType;
@property (nonatomic, assign) FRCreateEventCellType type;
@property (nonatomic, assign) BOOL hideTextField;

- (NSAttributedString*)attributedTitle;

@end
