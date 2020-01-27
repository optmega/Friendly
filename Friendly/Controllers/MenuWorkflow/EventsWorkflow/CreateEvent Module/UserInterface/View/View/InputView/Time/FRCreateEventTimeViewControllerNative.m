//
//  FRCreateEventTimeViewControllerNative.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventTimeViewControllerNative.h"
#import "FRCreateEventBaseInpute.h"

@interface FRCreateEventTimeViewControllerNative ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) FRCreateEventBaseInpute* timeView;
@property (nonatomic, strong) NSString* chosenTime;

@end

static CGFloat const kHeight = 340;

@implementation FRCreateEventTimeViewControllerNative

-  (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightFooter = kHeight;
        self.eventTime = [NSDate date];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timePicker setDate:self.eventTime animated:NO];
    [self timePicker];
    [self titleLabel];
    [self.timeView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeView.cancelButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction:(UIButton*)sender
{
    if (sender == self.timeView.cancelButton)
    {
        [self.delegate didSelectTime:self.timePicker.date];
    }
    [self closeVC];
}


//- (void)pickerChanged:(id)sender
//{
//    NSDate* chosenDate = [self.timePicker date];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"h:mm a"];
//    self.chosenTime = [formatter stringFromDate:chosenDate];
//    NSLog(@"value: %@",[sender date]);
//    }



#pragma mark - LazyLoad

- (FRCreateEventBaseInpute*)timeView
{
    if (!_timeView)
    {
        _timeView = [FRCreateEventBaseInpute new];
        _timeView.layer.masksToBounds = YES;
        [self.footerView addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.footerView);
        }];
    }
    return _timeView;
}

- (UIDatePicker*) timePicker
{
    if (!_timePicker)
    {
        _timePicker = [UIDatePicker new];
        _timePicker.backgroundColor = [UIColor clearColor];
        _timePicker.datePickerMode = UIDatePickerModeTime;
        [self.timeView addSubview:_timePicker];
        
        [_timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeView.headerView.mas_bottom).offset(20);
            make.bottom.equalTo(self.timeView.cancelButton.mas_top).offset(-40);
           // make.height.equalTo(@80);
            make.left.right.equalTo(self.timeView);
        }];
    }
    return _timePicker;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.text = FRLocalizedString(@"Select a time", nil);
        [self.timeView.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.timeView.headerView);
        }];
    }
    return _titleLabel;
}

- (NSDate*) eventTime
{
    if (!_eventTime)
    {
        _eventTime = [NSDate date];
    }
    return _eventTime;
}


@end
