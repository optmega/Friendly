//
//  FRHomeEventTableHeaderView.m
//  Friendly
//
//  Created by Sergey on 04.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHomeEventTableHeaderView.h"
#import "EAIntroView.h"
#import "FREventCollectionCellFooter.h"
#import "FREventsCellViewModel.h"
#import "FREventCollectionCellFooterViewModel.h"
#import "FRStyleKit.h"

#import "UIScrollView+TwitterCover.h"
#import "UIImageView+LBBlurredImage.h"


@implementation FRHomeEventTableHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.eventImage.translatesAutoresizingMaskIntoConstraints = false;
    self.blurView.translatesAutoresizingMaskIntoConstraints = false;
    self.footerView.translatesAutoresizingMaskIntoConstraints = false;
    
    
    self.footerView.joinButton.hidden = true;
   
    self.eventImage.image = [FRStyleKit imageOfArtboard121Canvas];
    
//    self.titleLabel.layer.drawsAsynchronously = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    
    [self.titleLabel sizeToFit];
    _titleLabel.shadowOffset = CGSizeMake(-1.5, 2);
    _titleLabel.font = FONT_VENTURE_EDDING_BOLD(50);
    
    
    
    self.mainUserPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    self.partnerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
    [_shareButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
 
//    self.shareButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    self.shareButton.layer.cornerRadius = 16;
//    self.shareButton.layer.drawsAsynchronously = YES;
//    self.shareButton.layer.masksToBounds = NO;    
//    self.shareButton.tintColor = [UIColor whiteColor];
    self.shareButton.hidden = true;
    self.partnerImage.hidden = YES;
    @weakify(self);
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
                    [self.viewModel selectedShare];
    }];
    
    self.eventImage.userInteractionEnabled = true;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
    
    [self.mainUserPhoto addGestureRecognizer:tap];
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPartnerProfile)];
    [self.partnerImage addGestureRecognizer:tap1];
    UITapGestureRecognizer* eventSelecred = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventSelected)];
    [self.eventImage addGestureRecognizer:eventSelecred];
    
    [self updateAlpha:0];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.blackSeparator = [UIView new];
    self.blackSeparator.backgroundColor = [UIColor blackColor];
    [self addSubview:self.blackSeparator];
    [self.blackSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@15);
    }];

    self.blackSeparator.hidden = true;
    
}


- (void)updateAlpha:(CGFloat)alpha
{
    alpha = 0;
    self.mainUserPhoto.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.footerView.alpha = alpha;
    self.partnerImage.alpha = alpha;
    self.awayLabel.alpha = alpha;
    self.genderImage.alpha = alpha;
}

- (instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:@"FRHomeEventTableHeaderView"
                                         owner:self
                                       options:nil].firstObject;
    
    self.tempImage1 = [UIImageView new];
    
    return self;
}



- (void)tapGest
{
    [self.viewModel userPhotoSelected];
}

- (void)eventSelected
{
    [self.viewModel selectedEvent];
}

- (void)showPartnerProfile
{
    [self.viewModel partnerPhotoSelected];
}

- (void)updateWithModel:(FREventsCellViewModel*)model
{
    self.viewModel = model;
    self.model = [model domainModel];
    [self.awayLabel setText:model.distance];
    
    self.titleLabel.text = self.model.title;
    [model updateUserPhoto:self.mainUserPhoto];
    
    [self _setGender:[self.model.gender integerValue]];
    
    FREventCollectionCellFooterViewModel* footerModel = [FREventCollectionCellFooterViewModel initWithModel:self.model];
    [self.footerView updateWithModel:footerModel];
    
    [self _setEventRequestStatusType:[self.model.requestStatus integerValue]];
    
    [model updateEventPhoto:self.eventImage tempImage:self.tempImage1];
    
    if ((self.model.partnerHosting != nil)&& self.model.partnerIsAccepted.boolValue )
    {
        [self _updateWithPartner];
         self.userImageCenterConstr.constant = - 20;
    }
    else
    {
        self.partnerImage.hidden = YES;
        self.userImageCenterConstr.constant = 0;
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

- (void)_updateWithPartner
{
   
    [self.viewModel updatePartnerPhoto:self.partnerImage];
    self.partnerImage.hidden = NO;
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


@end



