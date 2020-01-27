//
//  DateView.m
//  Project
//
//  Created by Zaslavskaya Yevheniya on 01.03.16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import "FREventPreviewDateView.h"
#import "FRDateManager.h"

@interface FREventPreviewDateView()

@property (strong, nonatomic) UILabel* dayOfWeekLabel;
@property (strong, nonatomic) UILabel* dayLabel;
@property (strong, nonatomic) UIView* separator;

@end

@implementation FREventPreviewDateView

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self dayLabel];
        [self dayOfWeekLabel];
        [self separator];
    }
    return self;
}

- (void)updateWithModel:(FREventPreviewEventViewCellViewModel*)model
{
    NSString* dayOfWeek = [[FRDateManager dayOfWeek:model.date] uppercaseString];
    self.dayOfWeekLabel.text = dayOfWeek;
    NSString* dayOfMonth = [[FRDateManager dayOfMonth:model.date] uppercaseString];
    self.dayLabel.text = dayOfMonth;
}


#pragma mark - LazyLoad

-(UILabel*) dayOfWeekLabel
{
    if (!_dayOfWeekLabel)
    {
        _dayOfWeekLabel = [UILabel new];
        [_dayOfWeekLabel setTextColor:[UIColor bs_colorWithHexString:@"#FF5454"]];
        _dayOfWeekLabel.text = @"SAT";
        _dayOfWeekLabel.font = [UIFont boldSystemFontOfSize:10];
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
        _dayLabel.font = [UIFont systemFontOfSize:22];
        [self addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOfWeekLabel.mas_bottom);
            make.centerX.equalTo(self);
        }];
    }
    return _dayLabel;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.right.equalTo(self);
            make.width.equalTo(@2);
        }];
    }
    return _separator;
}

@end
