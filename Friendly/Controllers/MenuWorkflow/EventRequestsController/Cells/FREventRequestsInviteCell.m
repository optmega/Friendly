//
//  FREventRequestsInviteCell.m
//  Friendly
//
//  Created by Jane Doe on 4/7/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsInviteCell.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"
#import "FREventTransport.h"
#import "FRRequestTransport.h"
#import "FRSettingsTransport.h"

@interface FREventRequestsInviteCell()

@property (nonatomic, strong) UIImageView* avatar;
@property (nonatomic, strong) UILabel* nameAgeLabel;
@property (nonatomic, strong) UILabel* friendsSinceLabel;
@property (nonatomic, strong) UILabel* eventTitleLabel;
@property (nonatomic, strong) UIButton* toEventButton;
@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UILabel* weekdayLabel;
@property (nonatomic, strong) UIView* verticalSeparator;
@property (nonatomic, strong) UIButton* joinButton;
@property (nonatomic, strong) UIButton* declineButton;
@property (nonatomic, strong) UIView* horizontalSeparator;
@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, strong) NSString* inviteId;
@property (nonatomic, assign) BOOL isPartnerCell;
@property (nonatomic, strong) UILabel* eventFull;
@property (nonatomic, strong) UIView* greyView;
@property (nonatomic, assign) BOOL isCreatorsInvite;
@property (nonatomic, strong) UIView* toEventView;
@property (nonatomic, strong) FRInviteModel* model;
@property (nonatomic, strong) NSString* creatorId;
@property (nonatomic, strong) FREventModel* event;
@end

#define kButtonWidth ([UIScreen mainScreen].bounds.size.width/2-20)/2)

@implementation FREventRequestsInviteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self avatar];
        [self nameAgeLabel];
        [self friendsSinceLabel];
        [self declineButton];
        [self horizontalSeparator];
        [self weekdayLabel];
        [self verticalSeparator];
        [self joinButton];
        [self declineButton];
        [self dayLabel];
        [self toEventButton];
        [self eventTitleLabel];
        self.eventFull.hidden = YES;
        self.greyView.hidden  = YES;
        [self toEventView];
    }
    return self;
}

-(void) showEvent
{
    FREvent* event = [FREvent initWithEvent:self.event withType:[self.event.event_type integerValue] inContext:[NSManagedObjectContext MR_defaultContext]];
    [self.delegate showEventWithModel:event];
}

-(void) joinEvent
{
    if (self.isPartnerCell)
    {
        [self.delegate acceptPartnerForEventId:self.eventId];
    }
    else if (self.isCreatorsInvite)
    {
        [self.delegate acceptInviteWithId:self.inviteId];
    }
    else
    {
        [self.delegate joinEventWithId:self.eventId andModel:[FREvent initWithEvent:self.event withType:[self.event.event_type integerValue] inContext:[NSManagedObjectContext MR_defaultContext]]];
    }
}

-(void) declineEvent
{
    if (self.isPartnerCell)
    {
        [self.delegate declinePartnerForEventId:self.eventId];
    }
    else
    {
    [self.delegate declineEventWithId:self.inviteId];
    }
}

-(void) updateWithFullStatus
{
    self.joinButton.hidden = YES;
    self.declineButton.hidden = YES;
    self.eventFull.hidden = NO;
    self.greyView.hidden = NO;
}

-(void) updateWithModel:(FRInviteModel*)model
{
    self.creatorId = model.creator_id;
    self.model = model;
    self.event = model.event;
    self.eventId = model.event.id;
//    self.friendsSinceLabel.text = model.f
//    NSString* dayOfWeak =  [FRDateManager dayOfweekFromString:[FRDateManager dateStringFromDate:model.event.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]];
    NSDate* friendsSince = [FRDateManager dateFromServerWithString:self.model.creator.friends_since];

    self.friendsSinceLabel.text = [NSString stringWithFormat:@"Friends since %@", [FRDateManager dateStringFromDate:friendsSince withFormat:@"dd/MM"]];
    NSString* dayOfWeak =  [FRDateManager dayOfweekFromString:model.event.event_start];

    self.weekdayLabel.text = dayOfWeak;
    NSString* dayOfMonth = [FRDateManager dayOfMonthFromString:model.event.event_start];
    self.dayLabel.text = dayOfMonth;
    
    NSDate* birthday = [FRDateManager dateFromBirthdayFormat:model.creator.birthday];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                   components:NSCalendarUnitYear 
                                   fromDate:birthday
                                   toDate:[NSDate date]
                                   options:0];
    NSInteger age = [ageComponents year];
    if (age == 0)
    {
        self.nameAgeLabel.text = model.creator.first_name;
    }
    else
    {
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %ld", model.creator.first_name, (long)age];
    }
    
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.creator.photo]];
    [self.avatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    self.eventTitleLabel.text = model.event.title;
    self.inviteId = model.id;
    if (model.event_is_full == YES)
    {
        [self updateWithFullStatus];
    }
    if (([model.creator_id isEqualToString:model.event.creator_id])||([model.is_invited_from_fb isEqualToString:@"1"]))
    {
        self.isCreatorsInvite = YES;
    }
    else
    {
        self.isCreatorsInvite = NO;
    }
    [self updateWithInvite];
}

-(void) updateWithInvite
{
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.joinButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
}

-(void) updateWithInvitePartnerModel:(FRInviteToPartnerModel*)model
{
    self.creatorId = model.event.creator_id;
    self.event = model.event;
    self.isPartnerCell = YES;
    self.eventId = model.event.id;
    NSString* dayOfWeak =  [FRDateManager dayOfweekFromString:model.event.event_start];
    self.weekdayLabel.text = dayOfWeak;
    NSString* dayOfMonth = [FRDateManager dayOfMonthFromString:model.event.event_start];
    self.dayLabel.text = dayOfMonth;
    
    NSDate* birthday = [FRDateManager dateFromBirthdayFormat:model.event.creator.birthday];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    if (age == 0)
    {
        self.nameAgeLabel.text = model.event.creator.first_name;
    }
    else
    {
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %ld", model.event.creator.first_name, (long)age];
    }

//    self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %ld", model.creator.first_name, (long)age];
    
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.event.creator.photo]];
    [self.avatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    self.eventTitleLabel.text = model.event.title;
    NSDate* friendsSince = [FRDateManager dateFromServerWithString:model.event.creator.friends_since];
    self.friendsSinceLabel.text = [NSString stringWithFormat:@"Friends since %@", [FRDateManager dateStringFromDate:friendsSince withFormat:@"dd/MM"]];

    self.inviteId = model.id;
}

-(void) updateWithInviteToCoHost
{
    [self.joinButton setTitle:@"Co-host" forState:UIControlStateNormal];
    [self.joinButton setBackgroundColor:[UIColor bs_colorWithHexString:kFriendlyBlueColor]];
}

-(void)showProfile
{
    UserEntity* user = [FRSettingsTransport getUserWithId:self.creatorId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
    } failure:^(NSError *error) {
        //
    }];
    [self.delegate showUserProfileWithEntity:user];
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
            make.height.equalTo(@30);
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
        [_weekdayLabel setText:@"FRI"];
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
        [_eventTitleLabel setText:@"Gym buddy needed!"];
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

-(UIImageView*) avatar
{
    if (!_avatar)
    {
        _avatar = [UIImageView new];
        [_avatar setBackgroundColor:[UIColor blackColor]];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 20;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatar addGestureRecognizer:singleTap];
        _avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatar];
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.eventTitleLabel.mas_bottom).offset(25);
            make.width.height.equalTo(@40);
        }];
    }
    return _avatar;
}

-(UILabel*) nameAgeLabel
{
    if (!_nameAgeLabel)
    {
        _nameAgeLabel = [UILabel new];
        [_nameAgeLabel setText:@"Brian, 28"];
        [_nameAgeLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        _nameAgeLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [self.contentView addSubview:_nameAgeLabel];
        [_nameAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.bottom.equalTo(self.avatar.mas_centerY);
        }];
    }
    return _nameAgeLabel;
}

-(UILabel*) friendsSinceLabel
{
    if (!_friendsSinceLabel)
    {
        _friendsSinceLabel = [UILabel new];
        [_friendsSinceLabel setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [_friendsSinceLabel setText:@"Friends since 11/02"];
        _friendsSinceLabel.adjustsFontSizeToFitWidth = YES;
        _friendsSinceLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        [self.contentView addSubview:_friendsSinceLabel];
        [_friendsSinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.top.equalTo(self.avatar.mas_centerY);
            make.right.equalTo(self.joinButton.mas_left);
        }];
    }
    return _friendsSinceLabel;
}

-(UIButton*) joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [_joinButton addTarget:self action:@selector(joinEvent) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _joinButton.layer.cornerRadius = 5;
        [_joinButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [self.contentView addSubview:_joinButton];
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.nameAgeLabel);
            make.bottom.equalTo(self.friendsSinceLabel);
            make.width.equalTo(@(kButtonWidth);
        }];
    }
    return _joinButton;
           
}

-(UIView*) horizontalSeparator
{
    if (!_horizontalSeparator)
    {
       _horizontalSeparator = [UIView new];
       [_horizontalSeparator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_horizontalSeparator];
        [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
     }
     return _horizontalSeparator;
}
                               
-(UIButton*) declineButton
{
    if (!_declineButton)
    {
        _declineButton = [UIButton new];
        [_declineButton setTitle:@"Decline" forState:UIControlStateNormal];
        [_declineButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_declineButton addTarget:self action:@selector(declineEvent) forControlEvents:UIControlEventTouchUpInside];
        _declineButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _declineButton.layer.borderWidth = 1;
        _declineButton.layer.cornerRadius = 5;
        _declineButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        [self.contentView addSubview:_declineButton];
        [_declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.joinButton.mas_right).offset(5);
             make.top.equalTo(self.joinButton);
             make.height.equalTo(self.joinButton);
             make.width.equalTo(@(kButtonWidth);
        }];
    }
    return _declineButton;
}

-(UILabel*) eventFull
{
    if (!_eventFull)
    {
        _eventFull = [UILabel new];
        [_eventFull setText:@"Event is full"];
        [_eventFull setTextColor:[UIColor bs_colorWithHexString:kAlertsColor]];
        _eventFull.font = FONT_SF_DISPLAY_REGULAR(14);
        [self.greyView addSubview:_eventFull];
        [self bringSubviewToFront:_eventFull];
        [_eventFull mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.toEventButton);
            make.bottom.equalTo(self.friendsSinceLabel);
        }];
    }
    return _eventFull;
}

-(UIView*) greyView
{
    if (!_greyView)
    {
        _greyView = [UIView new];
        [_greyView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        [self.contentView addSubview:_greyView];
        [_greyView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.contentView);
        }];
    }
    return _greyView;
}
                                
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
        [self.contentView bringSubviewToFront:_toEventView];
        [_toEventView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];
    }
    return _toEventView;
}


@end
