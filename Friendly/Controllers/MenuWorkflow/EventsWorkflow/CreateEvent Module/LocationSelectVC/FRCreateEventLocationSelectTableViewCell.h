//
//  FRCreateEventLocationSelectTableViewCell.h
//  Friendly
//
//  Created by Jane Doe on 3/30/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRLocationManager.h"
#import "FRCreateEventLocationPlaceModel.h"


@interface FRCreateEventLocationSelectTableViewCell : UITableViewCell


- (void) updateCell:(FRCreateEventLocationPlaceModel*)response :(NSString*)icon :(BOOL)isSeparator;

@property (nonatomic, strong) FRCreateEventLocationPlaceModel* selectedResponse;
@property (nonatomic, strong) UIView* separator;

@end
