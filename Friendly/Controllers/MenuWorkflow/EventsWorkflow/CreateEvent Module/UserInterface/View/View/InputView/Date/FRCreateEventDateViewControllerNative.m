//
//  FRCreateEventDateViewControllerNative.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventDateViewControllerNative.h"
#import "FRCreateEventBaseInpute.h"

@interface FRCreateEventDateViewControllerNative ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* descriptionLabel;

@property (nonatomic, assign) BOOL isSelectedFirst;
@property (nonatomic, strong) FRCreateEventBaseInpute* dateView;


@end

@implementation FRCreateEventDateViewControllerNative

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.heightFooter = 290;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datePicker setDate:self.eventDate animated:NO];
    [self dateView];
    [self datePicker];
    [self descriptionLabel];
    [self titleLabel];
    [self.dateView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView.cancelButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction:(UIButton*)sender
{
   if (sender == self.dateView.cancelButton)
   {
        [self.delegate selectedDate:self.datePicker.date];
        [self closeVC];
   }
    [self closeVC];
}


#pragma mark - Lazy Load

- (FRCreateEventBaseInpute*)dateView
{
    if (!_dateView)
    {
        _dateView = [FRCreateEventBaseInpute new];
        _dateView.layer.masksToBounds = YES;
        [self.footerView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.footerView);
        }];
    }
    return _dateView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.text = FRLocalizedString(@"Select a date", nil);
        [self.dateView.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.dateView.headerView);
        }];
    }
    return _titleLabel;
}

- (UILabel*) descriptionLabel
{
    if (!_descriptionLabel)
    {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.text = FRLocalizedString(@"Events can only be planned two weeks in advance", nil);
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.font = FONT_SF_DISPLAY_REGULAR(14);//[UIFont fontWithName:@"SFUIDisplay-Regular" size:14.0f];
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        _descriptionLabel.textColor = [UIColor bs_colorWithHexString:@"B4B7BF"];
        [self.dateView addSubview:_descriptionLabel];
        [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateView).offset(20);
            make.right.equalTo(self.dateView).offset(-20);
            make.bottom.equalTo(self.dateView.cancelButton.mas_top).offset(-15);
        }];
    }
    
    return _descriptionLabel;
}

- (UIDatePicker*) datePicker
{
    if (!_datePicker)
    {
        _datePicker = [UIDatePicker new];
        _datePicker.minimumDate = [NSDate date];
        NSDate *date = [NSDate date];
        NSDateComponents *comp = [NSDateComponents new];
        comp.weekOfYear = 2;
        NSDate *date1 = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
        _datePicker.maximumDate = date1;
        _datePicker.backgroundColor = [UIColor clearColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [self.dateView addSubview:_datePicker];
        
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateView.headerView.mas_bottom).offset(20);
            make.bottom.equalTo(self.dateView.cancelButton.mas_top).offset(-40);
           // make.height.equalTo(@80);
            make.left.right.equalTo(self.dateView);
        }];
    }
    return _datePicker;
}

- (NSDate*) eventDate
{
    if (!_eventDate)
    {
        _eventDate = [NSDate date];
    }
    return _eventDate;
}



@end
