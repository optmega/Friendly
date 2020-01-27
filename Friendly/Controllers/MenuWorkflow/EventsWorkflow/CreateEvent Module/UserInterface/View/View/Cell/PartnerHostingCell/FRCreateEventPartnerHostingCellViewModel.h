//
//  FRCreateEventPartnerHostingCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRCreateEventPartnerHostingCellViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* contentTitle;

@property (nonatomic, strong) NSArray* contentArray;
@property (nonatomic, strong) NSString* partnerId;
//@property (nonatomic, assign) FRCreateEventCellType type;

@end
