//
//  FREventRequestsToJoinHeader.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsToJoinHeader.h"
#import "FRStyleKit.h"
#import "FRDateManager.h"

@interface FREventRequestsToJoinHeader()

@property (nonatomic, strong) UIView* upperGreyView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* horizontalSeparator;
@property (nonatomic, strong) UILabel* eventTitleLabel;
@property (nonatomic, strong) UIButton* toEventButton;
@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UILabel* weekdayLabel;
@property (nonatomic, strong) UIView* verticalSeparator;
@property (nonatomic, strong) FREventRequestsToJoinHeaderModel* model;
@property (nonatomic, strong) UIView* toEventView;

@end

@implementation FREventRequestsToJoinHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upperGreyView];
        [self headerView];
        [self titleLabel];
        [self horizontalSeparator];
        [self eventTitleLabel];
        [self toEventButton];
        [self dayLabel];
        [self weekdayLabel];
        [self toEventView];
        [self verticalSeparator];
    }
    return self;
}

-(void)showEvent
{
    [self.delegate showEventWithModel:self.model.event];
}

- (void) updateWithModel:(FREventRequestsToJoinHeaderModel*)model
{
    self.model = model;
    NSString* dayOfWeak =  [FRDateManager dayOfweekFromString:[FRDateManager dateStringFromDate:model.event.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]];
    self.weekdayLabel.text = dayOfWeak;
    NSString* dayOfMonth = [FRDateManager dayOfMonthFromString:[FRDateManager dateStringFromDate:model.event.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]];
    self.dayLabel.text = dayOfMonth;
    self.eventTitleLabel.text = model.eventTitle;
    
}


#pragma mark - LazyLoad

-(UIView*)toEventView
{
    if (!_toEventView)
    {
        _toEventView = [UIView new];
        [_toEventView setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEvent)];
        [singleTap setNumberOfTapsRequired:1];
        [_toEventView addGestureRecognizer:singleTap];
        _toEventView.userInteractionEnabled = YES;
        [self.contentView addSubview:_toEventView];
        [_toEventView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.horizontalSeparator);
            make.bottom.equalTo(self.headerView);
        }];
    }
    return _toEventView;
}

-(UIView*) upperGreyView
{
    if (!_upperGreyView)
    {
        _upperGreyView = [UIView new];
        [_upperGreyView setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_upperGreyView];
        [_upperGreyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.top.left.right.equalTo(self.contentView);
        }];
    }
    return _upperGreyView;
}

-(UIView*) headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_headerView];
               [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.upperGreyView.mas_bottom);
            make.height.equalTo(@95);
        }];
    }
    return _headerView;
}

-(UIView*) horizontalSeparator
{
    if (!_horizontalSeparator)
    {
        _horizontalSeparator = [UIView new];
        [_horizontalSeparator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.headerView addSubview:_horizontalSeparator];
        [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView).offset(50);
            make.left.right.equalTo(self.headerView);
            make.height.equalTo(@1);
        }];
    }
    return _horizontalSeparator;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        [_titleLabel setText:@"REQUEST TO JOIN"];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [self.headerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(15);
            make.centerY.equalTo(self.headerView).offset(-20);
        }];
    }
    return _titleLabel;
}

-(UIButton*) toEventButton
{
    if (!_toEventButton)
    {
        _toEventButton = [UIButton new];
        [_toEventButton setImage:[FRStyleKit imageOfFeildChevroneCanvas] forState:UIControlStateNormal];
        [self.headerView addSubview:_toEventButton];
        [_toEventButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerView).offset(-10);
            make.centerY.equalTo(self.verticalSeparator);
            make.width.height.equalTo(@20);
        }];
    }
    return _toEventButton;
}

-(UIView*) verticalSeparator
{
    if (!_verticalSeparator)
    {
        _verticalSeparator = [UIView new];
        [_verticalSeparator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.headerView addSubview:_verticalSeparator];
        [_verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(50);
            make.top.equalTo(self.horizontalSeparator).offset(8);
            make.bottom.equalTo(self.headerView).offset(-8);
            make.width.equalTo(@1);
        }];
    }
    return _verticalSeparator;
}

-(UILabel*) dayLabel
{
    if (!_dayLabel)
    {
        _dayLabel = [UILabel new];
        [_dayLabel setText:@"20"];
        [_dayLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        _dayLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        [self.headerView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.verticalSeparator).offset(1);
            make.right.equalTo(self.verticalSeparator).offset(-10);
        }];
    }
    return _dayLabel;
}

-(UILabel*) weekdayLabel
{
    if (!_weekdayLabel)
    {
        _weekdayLabel = [UILabel new];
        [_weekdayLabel setTextColor:[UIColor bs_colorWithHexString:kAlertsColor]];
        [_weekdayLabel setText:@"FRI"];
        _weekdayLabel.font = FONT_SF_DISPLAY_SEMIBOLD(9);
        [self.headerView addSubview:_weekdayLabel];
        [_weekdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verticalSeparator).offset(-1);
            make.centerX.equalTo(self.dayLabel);
        }];
    }
    return _weekdayLabel;
}

-(UILabel*) eventTitleLabel
{
    if (!_eventTitleLabel)
    {
        _eventTitleLabel = [UILabel new];
        [_eventTitleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
       // [_eventTitleLabel setText:@"Gym buddy needed!"];
        _eventTitleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [self.headerView addSubview:_eventTitleLabel];
        [_eventTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verticalSeparator).offset(10);
            make.centerY.equalTo(self.verticalSeparator);
            make.right.equalTo(self.toEventButton.mas_left).offset(-2);
        }];
    }
    return _eventTitleLabel;
}

@end
