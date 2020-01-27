//
//  FREventCollectionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventsCell.h"

#import "FREventCollectionCell.h"
#import "FRStyleKit.h"
#import "FREventModel.h"
#import "UIImageView+WebCache.h"

#import "UIImageHelper.h"
#import "UIImageView+WebCache.h"

#import "FREventCollectionCellFooterViewModel.h"
#import "FRDistanceLabel.h"
#import "FRUserManager.h"
#import "FRConnetctionManager.h"




@interface FREventsCell ()

@property (nonatomic, strong) FREvent* model;
@property (nonatomic, strong) FREventsCellViewModel* viewModel;

@end

@implementation FREventsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView* mask = [UIImageView new];
        mask.image = [FRUserManager sharedInstance].normalEventImage;
        [self.eventImage addSubview:mask];
        [mask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.eventImage);
        }];

        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.footerView.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.eventImage.image = [FRUserManager sharedInstance].testImage;
        [self distanceLabel];
        self.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        self.footerView.joinButton.hidden = NO;
        self.partnerAvatar.hidden = YES;
        self.partnerBorederWidth.hidden = YES;
        @weakify(self);
        [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel selectedShare];
        }];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
        
        [self.userImage addGestureRecognizer:tap];
        
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPartnerProfile)];
        
        [self.partnerAvatar addGestureRecognizer:tap1];
        
        UITapGestureRecognizer* selectedEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedEvent)];
        [self.eventImage addGestureRecognizer:selectedEvent];
        
        
    }
    return self;
}

- (void)selectedEvent
{
    [self.viewModel selectedEvent];
}

- (void)tapGest
{
    [self.viewModel userPhotoSelected];
}

- (void)showPartnerProfile
{
    [self.viewModel partnerPhotoSelected];
}

- (void)joinAction:(UIButton*)sender
{
    if (![FRConnetctionManager isConnected]) {
        return;
    }
    
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
        if (![self.model.gender.stringValue isEqualToString:@"0"]&![self.model.gender.stringValue isEqualToString:genderIntegerValue])
        {

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ops" message:[NSString stringWithFormat:@"Ops it looks like the guest has only opened it to %@s", gender] delegate:self
                                                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertView show];
        }
        else
        {
            [self.viewModel joinEventSelected];
        }
    }
}

- (void)updateWithModel:(FREventsCellViewModel*)model
{
    model.cell = self;
    self.viewModel = model;
    self.model = [model domainModel];
    [self.distanceLabel setText:model.distance];
    self.titleLabel.text = self.model.title;
    [model updateUserPhoto:self.userImage];
    
    [self _setGender:[self.model.gender integerValue]];
    
    FREventCollectionCellFooterViewModel* footerModel = [FREventCollectionCellFooterViewModel initWithModel:self.model];
    [self.footerView updateWithModel:footerModel];
   
    
   
    [self _setEventRequestStatusType:[self.model.requestStatus integerValue]];

    [self _setEventType:[self.model.eventType integerValue]];
    [model updateEventPhoto:self.eventImage tempImage:nil];
    
    if ((self.model.partnerHosting != nil)&& self.model.partnerIsAccepted.boolValue )
    {
        [self _updateWithPartner];
    }
    else
    {
        self.partnerAvatar.hidden = YES;
        self.partnerBorederWidth.hidden = YES;
        [self.userImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
    }
    if ((self.model.memberUsers.count == [self.model.slots integerValue])&&(self.model.requestStatus == nil))
    {
        self.footerView.joinButton.hidden = YES;
    }
    else
    {
        self.footerView.joinButton.hidden = NO;
    }
    
    
    self.footerView.joinButton.hidden = [self.model.creator.user_id isEqualToString:[FRUserManager sharedInstance].userId];
}

- (void)_updateWithPartner
{
    [self.userImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-15);
    }];
    NSURL* url = [NSURL URLWithString:self.model.partnerUser.photo];
    [self.partnerAvatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            self.partnerAvatar.image = image;
        }
    }];

    self.partnerAvatar.hidden = NO;
    self.partnerBorederWidth.hidden = NO;
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



#pragma mark - Lazy Load

- (UIView*)contentForEvent
{
    if (!_contentForEvent)
    {
        _contentForEvent = [UIView new];
        [self.contentView addSubview:_contentForEvent];
        [_contentForEvent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _contentForEvent;
}
- (UIImageView*)eventImage
{
    if (!_eventImage)
    {
        _eventImage = [UIImageView new];
        _eventImage.image = [FRStyleKit imageOfArtboard121Canvas];
//        _eventImage.layer.drawsAsynchronously = YES;
                _eventImage.contentMode = UIViewContentModeScaleAspectFill;
        _eventImage.clipsToBounds = YES;
        _eventImage.userInteractionEnabled = YES;
        [self.contentForEvent addSubview:_eventImage];
        
        [_eventImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentForEvent).offset(10);
            make.right.left.equalTo(self.contentForEvent);
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
//        _userImage.layer.drawsAsynchronously = YES;
        _userImage.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        _userImage.userInteractionEnabled = YES;
        _userImage.layer.cornerRadius = 20;
//        _userImage.layer.borderWidth = 2;
        _userImage.layer.zPosition = 2;
        _userImage.clipsToBounds = YES;
        _userImage.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.eventImage insertSubview:_userImage aboveSubview:self.partnerAvatar];
        
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@40);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-7);
            make.centerX.equalTo(self.eventImage);
            
        }];

        
        
        UIView* borederWidth = [UIView new];
        borederWidth.backgroundColor = [UIColor whiteColor];
        borederWidth.layer.cornerRadius = 22;
        
        [self.eventImage addSubview:borederWidth];
        borederWidth.layer.zPosition = 1;
        
        [borederWidth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.center.equalTo(_userImage);
        }];
        
        
        
           }
    return _userImage;
}

- (UIImageView*)partnerAvatar
{
    if (!_partnerAvatar)
    {
        _partnerAvatar = [UIImageView new];
//        _partnerAvatar.layer.drawsAsynchronously = YES;
        _partnerAvatar.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        _partnerAvatar.userInteractionEnabled = YES;
        _partnerAvatar.layer.cornerRadius = 20;
//        _partnerAvatar.layer.borderWidth = 2;
        _partnerAvatar.clipsToBounds = YES;
        _partnerAvatar.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        _partnerAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        _partnerAvatar.layer.zPosition = 1;
//        [self.eventImage insertSubview:_partnerAvatar aboveSubview:self.userImage];
      
        [self.eventImage addSubview:_partnerAvatar];
        [_partnerAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@40);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-7);
            make.centerX.equalTo(self.eventImage).offset(15);
           
        }];
        
        _partnerBorederWidth = [UIView new];
        _partnerBorederWidth.backgroundColor = [UIColor whiteColor];
        _partnerBorederWidth.layer.cornerRadius = 22;
        
        [self.eventImage addSubview:_partnerBorederWidth];
        _partnerBorederWidth.layer.zPosition = 0;
        
        [_partnerBorederWidth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.center.equalTo(_partnerAvatar);
        }];

        
    }
    return _partnerAvatar;
}

- (UIImageView*)genderImage
{
    if (!_genderImage)
    {
        _genderImage = [UIImageView new];
//        _genderImage.layer.drawsAsynchronously = YES;
        _genderImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.eventImage addSubview:_genderImage];
        [_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.eventImage).offset(-15);
            make.bottom.equalTo(self.eventImage).offset(-10);
            make.height.equalTo(@26);
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
//        _titleLabel.layer.drawsAsynchronously = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.shadowOffset = CGSizeMake(1.5, 2);
        
        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        
        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(38);
        [self.eventImage addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eventImage).offset(40);
            make.right.equalTo(self.eventImage).offset(-40);
            make.height.lessThanOrEqualTo(@70);
            make.centerY.equalTo(self.eventImage).offset(5);
        }];
    }
    return _titleLabel;
}

- (FRDistanceLabel*)distanceLabel
{
    if (!_distanceLabel)
        
    {
        _distanceLabel = [FRDistanceLabel new];
//        _distanceLabel.layer.drawsAsynchronously = YES;
        [_distanceLabel setText:@" 13KM AWAY "];
        _distanceLabel.font = FONT_SF_DISPLAY_BOLD(12);
        [_distanceLabel setTextColor:[UIColor whiteColor]];
        [_distanceLabel sizeToFit];
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.clipsToBounds = YES;
        [_distanceLabel setBackgroundColor:[[UIColor bs_colorWithHexString:@"1F1451"] colorWithAlphaComponent:1]];
        [self.eventImage addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentForEvent);
            make.height.equalTo(@20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
//            make.bottom.equalTo(self.eventImage).offset(-35);
//            make.width.lessThanOrEqualTo(@200);
            
//            make.bottom.equalTo(self.eventImage).offset(-15);
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 175;
            make.width.lessThanOrEqualTo(@(width));
            
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
        [_eventTypeButton setTitle:FRLocalizedString(@"FEATURED", nil) forState:UIControlStateNormal];
        [_eventTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eventTypeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _eventTypeButton.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        _eventTypeButton.layer.cornerRadius = 3;
//        _eventTypeButton.layer.drawsAsynchronously = YES;
        [self.contentForEvent addSubview:_eventTypeButton];
        
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
//        _shareButton.layer.drawsAsynchronously = YES;
        _shareButton.layer.masksToBounds = NO;
        _shareButton.tintColor = [UIColor grayColor];
        [_shareButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
        [self.eventImage addSubview:_shareButton];
        
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@32);
            make.right.equalTo(self.eventImage).offset(-10);
            make.top.equalTo(self.contentForEvent).offset(20);
        }];
    }
    return _shareButton;
}

- (FREventCollectionCellFooter*)footerView
{
    if (!_footerView)
    {
        _footerView = [FREventCollectionCellFooter new];
//        _footerView.layer.drawsAsynchronously = YES;
        [self.contentForEvent addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentForEvent);
            make.height.equalTo(@55);
        }];
    }
    return _footerView;
}
@end
