//
//  FRMyEventsDateView.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsDateView.h"
#import "FRDateManager.h"

@interface FRMyEventsDateView()


@end

@implementation FRMyEventsDateView

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self dayLabel];
        [self dayOfWeekLabel];
    }
    return self;
}

-(void)updateDateViewWithDate:(NSDate*)date
{
    if ([date isKindOfClass:[NSDate class]]) {
        
        NSString* dayOfWeek = [[FRDateManager dayOfWeek:date] uppercaseString];
        self.dayOfWeekLabel.text = dayOfWeek;
        NSString* dayOfMonth = [[FRDateManager dayOfMonth:date] uppercaseString];
        self.dayLabel.text = dayOfMonth;
    } else {
        NSString* dayOfWeek = [[FRDateManager dayOfweekFromString:(NSString*)date] uppercaseString];
        self.dayOfWeekLabel.text = dayOfWeek;
        NSString* dayOfMonth = [[FRDateManager dayOfMonthFromString:(NSString*)date] uppercaseString];
        self.dayLabel.text = dayOfMonth;
    }
}

-(void)updateWithDay:(NSString*)day andDayOfWeek:(NSString*)dayOfWeek
{
    self.dayOfWeekLabel.text = dayOfWeek;
    self.dayLabel.text = day;
}

#pragma mark - LazyLoad

-(UILabel*) dayOfWeekLabel
{
    if (!_dayOfWeekLabel)
    {
        _dayOfWeekLabel = [UILabel new];
        [_dayOfWeekLabel setTextColor:[UIColor bs_colorWithHexString:@"#FF5454"]];
        _dayOfWeekLabel.text = @"SAT";
        _dayOfWeekLabel.font = FONT_PROXIMA_NOVA_BOLD(10);
        [self addSubview:_dayOfWeekLabel];
        [_dayOfWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(5);
        }];
    }
    return _dayOfWeekLabel;
}

-(UILabel*) dayLabel
{
    if (!_dayLabel)
    {
        _dayLabel = [UILabel new];
        [_dayLabel setTextColor:[UIColor bs_colorWithHexString:@"#253244"]];
        [_dayLabel setText:@"20"];
        _dayLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(18);
        [self addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOfWeekLabel.mas_bottom).offset(-1);
            make.centerX.equalTo(self);
        }];
    }
    return _dayLabel;
}



@end
