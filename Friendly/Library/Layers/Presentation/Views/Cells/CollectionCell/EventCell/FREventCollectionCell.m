//
//  FREventCollectionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventCollectionCell.h"
#import "FRStyleKit.h"
#import "FREventCollectionCellFooter.h"
#import "FREventModel.h"
#import "UIImageView+WebCache.h"

#import "UIImageHelper.h"


//#import "FREventTransport.h"
#import "FREventCollectionCellFooterViewModel.h"
#import "FRDistanceLabel.h"
#import "FRUserManager.h"
#import "FREventCollectionCellViewModel.h"


@interface FREventCollectionCell ()



//@property (nonatomic, strong) UIImageView* distanceIcon;
@property (nonatomic, strong) UIButton* eventTypeButton;
@property (nonatomic, strong) FREventCollectionCellFooter* footerView;
@property (nonatomic, strong) FREventModel* model;
@property (nonatomic, strong) FREventCollectionCellViewModel* viewModel;


@end

//static NSInteger const kMaxSlots = 20;

@implementation FREventCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            
        [self distanceLabel];
        @weakify(self);
        [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel pressArrow];
        }];
        
        [[self.footerView.joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.footerView.joinButton.titleLabel.text isEqualToString:@"Join"])
            {
                    NSString* gender = [FRUserManager sharedInstance].userModel.gender;
                    NSString* genderIntegerValue = [NSString new];
                    if ([gender isEqualToString:@"male"])
                    {
                        genderIntegerValue = @"1";
                        gender = @"female";
                    }
                    else
                    {
                        genderIntegerValue = @"2";
                        gender = @"male";
                    }
                    if (![self.model.gender isEqualToString:@"0"]&![self.model.gender isEqualToString:genderIntegerValue])
                    {
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ops" message:[NSString stringWithFormat:@"Ops it looks like the guest has only opened it to %@s", gender] delegate:self
                                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else
                    {
                        [self.viewModel pressJoin];
                    }
            }
        }];
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserPhoto:)];
        [self.userImage addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapUserPhoto:(UIButton*)sender
{
    [self.viewModel pressUserPhoto];
}

- (void)updateViewModel:(FREventCollectionCellViewModel*)model
{
    self.viewModel = model;
    self.distanceLabel.text = model.distance;
    self.model = [model domainModel];
    self.titleLabel.text = self.model.title;
    
  
    [self _setGender:[self.model.gender integerValue]];
    
    self.footerView.joinButton.backgroundColor = self.model.isJoining ? [UIColor bs_colorWithHexString:@"E8EBF1"] : [UIColor bs_colorWithHexString:kPurpleColor];
    if ((self.model.users.count == [self.model.slots integerValue])&(self.model.request_status==nil))
    {
        self.footerView.joinButton.hidden = YES;
    }
    
    FREventCollectionCellFooterViewModel* footerModel = [FREventCollectionCellFooterViewModel initWithModel:self.model];
    [self.footerView updateWithModel:footerModel];
    [self eventTypeButton];
    [self _setEventType:[self.model.event_type integerValue]];
    [self _setEventRequestStatusType:[self.model.request_status integerValue]];

    
    [self.viewModel updateEventPhoto:self.eventImage];
    [self.viewModel updateUserPhoto:self.userImage];
    
}


- (void)_setEventType:(FREventType)eventType
{
    switch (eventType){
        case FREventTypeNew:
        {
            [self.eventTypeButton setTitle:FRLocalizedString(@"   NEW   ", nil) forState:UIControlStateNormal];
            self.eventTypeButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        } break;
        
        case FREventTypeFeatured:
        {
            [self.eventTypeButton setTitle:FRLocalizedString(@"   FEATURED   ", nil) forState:UIControlStateNormal];
            self.eventTypeButton.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        } break;
        
        case FREventTypePopular:
        {
            [self.eventTypeButton setTitle:FRLocalizedString(@"   POPULAR   ", nil) forState:UIControlStateNormal];
            self.eventTypeButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        } break;
    }
}

- (void)_setEventRequestStatusType:(FREventRequestStatusType)eventRequestStatusType
{
    switch (eventRequestStatusType){
        case FREventRequestStatusAvailableToJoin:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
            [self.footerView.joinButton setTitle:@"Join" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusPending:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.footerView.joinButton setTitle:@"Pending" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusAccepted:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
            [self.footerView.joinButton setTitle:@"Attending" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } break;
            
        case FREventRequestStatusDeclined:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
            [self.footerView.joinButton setTitle:@"Declined" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusUnsubscribe:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.footerView.joinButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } break;
        case FREventRequestStatusDiscard:
        {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.footerView.joinButton setTitle:@"Discard" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        } break;
            
        default: {
            self.footerView.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.footerView.joinButton setTitle:@"NoState" forState:UIControlStateNormal];
            [self.footerView.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            
    }
}

- (void)_setGender:(FRGenderType)gender
{
    switch (gender) {
        case FRGenderTypeAll: {
            self.genderImage.image = [FRStyleKit imageOfSexBoth];
            break;
        }
        case FRGenderTypeMale: {
            self.genderImage.image = [FRStyleKit imageOfSexMaleOnCanvas];

            break;
        }
        case FRGenderTypeFemale: {
            self.genderImage.image = [FRStyleKit imageOfSexFemaleOnCanvas];

            break;
        }
    }
    
    [self.genderImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.genderImage.image.size.width / 2));
    }];
}


#pragma mark - Lazy Load

- (UIImageView*)eventImage
{
    if (!_eventImage)
    {
        _eventImage = [UIImageView new];
//        _eventImage.contentMode = UIViewContentModeScaleAspectFill;
        _eventImage.userInteractionEnabled = YES;
        _eventImage.clipsToBounds = YES;
        _eventImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_eventImage];
        
        [_eventImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
            make.bottom.equalTo(self.footerView.mas_top);
        }];
    }
    return _eventImage;
}

- (UIImageView*)userImage
{
    if (!_userImage)
    {
        _userImage = [UIImageView new];
        _userImage.layer.cornerRadius = 37.5;
        _userImage.layer.borderWidth = 3;
        _userImage.clipsToBounds = YES;
        _userImage.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        _userImage.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        _userImage.layer.borderColor = [UIColor whiteColor].CGColor;

        _userImage.userInteractionEnabled = YES;
        [self.eventImage addSubview:_userImage];
        
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.eventImage);
//            make.top.equalTo(self.eventImage).offset(30);
            make.width.height.equalTo(@75);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-5);
        }];
    }
    return _userImage;
}

- (UIImageView*)genderImage
{
    if (!_genderImage)
    {
        _genderImage = [UIImageView new];
        _genderImage.contentMode = UIViewContentModeScaleAspectFit;
    
        [self.eventImage addSubview:_genderImage];
        
        [_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.eventImage).offset(-15);
            make.bottom.equalTo(self.eventImage).offset(-10);
            make.height.equalTo(@25);
//            make.width.equalTo(@60);
        }];
    }
    return _genderImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.shadowOffset = CGSizeMake(1.5, 2);

        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        
        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(50);
        [self.eventImage addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.userImage.mas_bottom).offset(5);
            make.left.equalTo(self.eventImage).offset(40);
            make.right.equalTo(self.eventImage).offset(-40);
//            make.bottom.equalTo(self.distanceLabel.mas_top).offset(0);
            make.centerY.equalTo(self.eventImage).offset(25);
        }];
    }
    return _titleLabel;
}

- (FRDistanceLabel*)distanceLabel
{
    if (!_distanceLabel)
        
    {
        _distanceLabel = [FRDistanceLabel new];
        _distanceLabel.font = FONT_SF_DISPLAY_BOLD(12);
        [_distanceLabel setTextColor:[UIColor whiteColor]];
        [_distanceLabel sizeToFit];
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.clipsToBounds = YES;
        [_distanceLabel setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
        [self.eventImage addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
//            make.bottom.equalTo(self.eventImage).offset(-35);
            make.width.lessThanOrEqualTo(@200);
        }];
    }
    return _distanceLabel;
}



- (UIButton*)eventTypeButton
{
    if (!_eventTypeButton)
    {
        _eventTypeButton = [UIButton new];
        _eventTypeButton.titleLabel.font = FONT_SF_DISPLAY_BOLD(10);
        [_eventTypeButton setTitle:FRLocalizedString(@"  FEATURED  ", nil) forState:UIControlStateNormal];
        [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eventTypeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _eventTypeButton.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        _eventTypeButton.layer.cornerRadius = 3;
        [self.contentView addSubview:_eventTypeButton];
        
        [_eventTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
//            make.width.equalTo(@65);
            make.left.equalTo(self.eventImage).offset(10);
            make.bottom.equalTo(self.eventImage).offset(-10);
        }];
    }
    return _eventTypeButton;
}

- (UIButton*)shareButton
{
    if (!_shareButton)
    {
        _shareButton = [UIButton new];
        _shareButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _shareButton.layer.cornerRadius = 16;
        _shareButton.layer.masksToBounds = NO;
        _shareButton.tintColor = [UIColor grayColor];
        [_shareButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
        [self.eventImage addSubview:_shareButton];
        
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@32);
            make.top.equalTo(self.eventImage).offset(10);
            make.right.equalTo(self.eventImage).offset(-10);
        }];
    }
    return _shareButton;
}

- (FREventCollectionCellFooter*)footerView
{
    if (!_footerView)
    {
        _footerView = [FREventCollectionCellFooter new];
        [self.contentView addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@55);
        }];
    }
    return _footerView;
}
@end
