//
//  FREventRequestsEventHeader.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsEventHeader.h"
#import "FRStyleKit.h"
#import "FRDateManager.h"

@interface FREventRequestsEventHeader()

@property (nonatomic, strong) UIButton* toEventButton;
@property (nonatomic, strong) UILabel* eventTitleLabel;
@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UILabel* weekdayLabel;
@property (nonatomic, strong) UIView* verticalSeparator;
@property (nonatomic, strong) FREventRequestsToJoinHeaderModel* model;
@property (nonatomic, strong) UIView* toEventView;

@end


@implementation FREventRequestsEventHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self toEventButton];
        [self toEventView];
        [self dayLabel];
        [self eventTitleLabel];
        [self weekdayLabel];
        [self verticalSeparator];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEvent)];
        [singleTap setNumberOfTapsRequired:1];
        [self.contentView addGestureRecognizer:singleTap];
        self.contentView.userInteractionEnabled = YES;
    }
    return self;
}

-(void)showEvent
{
    [self.delegate showEventWithModel:self.model.event];
}

- (void) updateWithModel:(FREventRequestsToJoinHeaderModel*)model
{
    self.eventTitleLabel.text = model.eventTitle;
    NSString* dayOfWeak =  [FRDateManager dayOfweekFromString:[FRDateManager dateStringFromDate:model.event.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]];
    self.weekdayLabel.text = dayOfWeak;
    NSString* dayOfMonth = [FRDateManager dayOfMonthFromString:[FRDateManager dateStringFromDate:model.event.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]];
    self.dayLabel.text = dayOfMonth;
    self.model = model;
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
            make.top.right.left.bottom.equalTo(self.contentView);
        }];
    }
    return _toEventView;
}


-(UIButton*) toEventButton
{
    if (!_toEventButton)
    {
        _toEventButton = [UIButton new];
        [_toEventButton setImage:[FRStyleKit imageOfFeildChevroneCanvas] forState:UIControlStateNormal];
        [self.contentView addSubview:_toEventButton];
        [_toEventButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
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
        [self.contentView addSubview:_verticalSeparator];
        [_verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(50);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(-8);
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
        [_dayLabel setText:@"23"];
        [_dayLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        _dayLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        [self.contentView addSubview:_dayLabel];
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
        [_weekdayLabel setText:@"MON"];
        _weekdayLabel.font = FONT_SF_DISPLAY_SEMIBOLD(9);
        [self.contentView addSubview:_weekdayLabel];
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
        [_eventTitleLabel setText:@"Fun run around cogee"];
        _eventTitleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [self.contentView addSubview:_eventTitleLabel];
        [_eventTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verticalSeparator).offset(10);
            make.centerY.equalTo(self.verticalSeparator);
            make.right.equalTo(self.toEventButton.mas_left).offset(-2);
        }];
    }
    return _eventTitleLabel;
}

@end
