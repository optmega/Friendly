//
//  FRShareEventCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventsCell.h"
#import "FRMyEventsDateView.h"

@interface FRShareEventCell : FREventsCell

@property (strong, nonatomic) FRMyEventsDateView* dateView;

@end
