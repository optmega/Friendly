//
//  FRMyEventsDateView.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRMyEventsDateView : UIView

@property (strong, nonatomic) UILabel* dayOfWeekLabel;
@property (strong, nonatomic) UILabel* dayLabel;

-(void)updateDateViewWithDate:(NSString*)date;
-(void)updateWithDay:(NSString*)day andDayOfWeek:(NSString*)dayOfWeek;

@end
