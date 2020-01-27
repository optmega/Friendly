
//
//  FRMyEventCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCell.h"
#import "FRDistanceLabel.h"
#import "FRStyleKit.h"
#import "FREventModel.h"
#import "FRMyEventsCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"

@interface FRMyEventsCell () <FRMyEventsCellToolbarDelegate>

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* arrowButton;
@property (strong, nonatomic) FRDistanceLabel* distanceLabel;
@property (strong, nonatomic) UIButton* typeButton;
@property (strong, nonatomic) UIImageView* genderImage;
@property (strong, nonatomic) FRMyEventsCellViewModel* model;
@property (strong, nonatomic) UIImageView* overlayImage;
@property (strong, nonatomic) UIImageView* headerView;

@end

@implementation FRMyEventsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self headerView];
        [self titleLabel];
        [self arrowButton];
        [self distanceLabel];
        [self typeButton];
        [self genderImage];
        [self footerView];
        [self dateView];
        [self overlayImage];
    }
    return self;
}

- (void)updateEventImage:(UIImage*)eventImage
{
    self.headerView.image = [FRStyleKit imageOfArtboard121Canvas];
    self.headerView.image = eventImage;
}

- (void)presentShareEventController
{
   [self.delegate presentShareEventControllerWithModel:self.model.eventModel];
}



- (void)showEvent
{
    [self.delegate showEventBySelectingRowWithModel:self.model.eventModel fromCell:self];
}

 
- (void) updateWithModel:(FRMyEventsCellViewModel*)model
{
    self.model = model;
    self.model.users = model.users;
//    [self.headerView sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:self.model.backImage]]];
    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.backImage]];
    [self.headerView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfArtboard121Canvas]];
    //self.headerView.image = [UIImage imageNamed:@"imageEvent"];
    self.titleLabel.text = model.title;
    [self.distanceLabel setText:model.distance];

    UIImage* image = nil;
    
    if ([model.gender integerValue] == FRGenderTypeAll)
    {
        image = [FRStyleKit imageOfSexBoth];
    }
    else if([model.gender integerValue] == FRGenderTypeMale)
    {
        image = [FRStyleKit imageOfSexMaleOnCanvas];
    }
    else if ([model.gender integerValue] == FRGenderTypeFemale)
    {
        image = [FRStyleKit imageOfSexFemaleOnCanvas];
    }
    
    [self.genderImage setImage:image];
    [self.genderImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.genderImage.image.size.width / 2));
    }];

    [self.footerView updateWithType:model.type];
    [self.footerView updateWithEvent:model.eventModel andUsers:model.users];
    
    [self _setEventType:[model.event_type integerValue]];
    [self.dateView updateDateViewWithDate: model.date];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 4;
    frame.size.height -= 2 * 4;
    [super setFrame:frame];
}

- (void)_setEventType:(FREventType)eventType
{
    switch (eventType){
        case FREventTypeNew:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   NEW   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        } break;
            
        case FREventTypeFeatured:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   FEATURED   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        } break;
            
        case FREventTypePopular:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   POPULAR   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        } break;
    }
}

#pragma mark - LazyLoad

-(UIButton*) arrowButton
{
    if (!_arrowButton)
    {
        _arrowButton = [UIButton new];
        [_arrowButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        _arrowButton.layer.masksToBounds = NO;
        [_arrowButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(presentShareEventController) forControlEvents:UIControlEventTouchUpInside];
        _arrowButton.layer.cornerRadius = 17.5;
        [self.headerView addSubview:_arrowButton];
        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView).offset(10);
            make.right.equalTo(self.headerView).offset(-10);
            make.width.height.equalTo(@35);
        }];
    }
    return _arrowButton;
}

-(UIImageView*) genderImage
{
    if (!_genderImage)
    {
        _genderImage = [UIImageView new];
        _genderImage.contentMode = UIViewContentModeScaleAspectFit;

        [self.headerView addSubview:_genderImage];
        [_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headerView).offset(-10);
            make.right.equalTo(self.headerView).offset(-10);
            make.height.equalTo(@25);
        }];
    }
    return _genderImage;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        [_titleLabel sizeToFit];
       // _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _titleLabel.shadowOffset = CGSizeMake(-1.5, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(36);
        [self.headerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView).offset(5);
            //   make.centerX.equalTo(self);
            make.left.equalTo(self.headerView).offset(40);
            make.right.equalTo(self.headerView).offset(-40);
            make.height.lessThanOrEqualTo(@70);
        }];
    }
    return _titleLabel;
}

-(FRDistanceLabel*) distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [FRDistanceLabel new];
        [_distanceLabel setText:@" 13KM AWAY"];
        _distanceLabel.font = FONT_SF_DISPLAY_BOLD(12);
        [_distanceLabel setTextColor:[UIColor whiteColor]];
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.clipsToBounds = YES;
        [_distanceLabel setBackgroundColor:[[UIColor bs_colorWithHexString:@"1F1451"] colorWithAlphaComponent:1]];
        [self.headerView addSubview:_distanceLabel];
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

-(UIButton*) typeButton
{
    if (!_typeButton)
    {
        _typeButton = [UIButton new];
        [_typeButton setBackgroundColor:[UIColor bs_colorWithHexString:@"#F6890A"]];
        _typeButton.layer.cornerRadius = 3;
        [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     //   [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [_typeButton setTitle:@"FEATURED" forState:UIControlStateNormal];
        _typeButton.titleLabel.font = FONT_SF_DISPLAY_BOLD(10);
        [self.headerView addSubview:_typeButton];
        [_typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
              make.height.equalTo(@18);
//            make.width.equalTo(@65);
            make.left.equalTo(self.headerView).offset(10);
            make.bottom.equalTo(self.headerView).offset(-10);
        }];
    }
    return _typeButton;
}

-(FRMyEventsDateView*) dateView
{
    if (!_dateView)
    {
        _dateView = [FRMyEventsDateView new];
        _dateView.layer.cornerRadius = 5;
        _dateView.backgroundColor = [UIColor whiteColor];
        _dateView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _dateView.layer.borderWidth = 3;
        [self.headerView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-5);
            make.width.height.equalTo(@37);
        }];
    }
    return _dateView;
}

-(UIImageView*) headerView
{
    if (!_headerView)
    {
        _headerView = [UIImageView new];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEvent)];
        [singleTap setNumberOfTapsRequired:1];
        [_headerView addGestureRecognizer:singleTap];
        _headerView.userInteractionEnabled = YES;
        [self.contentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.footerView.mas_top);
            make.height.equalTo(@160);
        }];
    }
    return _headerView;
}

-(FRMyEventsCellToolbar*) footerView
{
    if (!_footerView)
    {
        _footerView = [FRMyEventsCellToolbar new];
        [self.contentView addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@48);
        }];
    }
    return _footerView;
}

-(UIImageView*)overlayImage
{
    if (!_overlayImage)
    {
        _overlayImage = [UIImageView new];
        [_overlayImage setImage:[UIImage imageNamed:@"over-normal-event.png"]];
        [self.headerView insertSubview:_overlayImage atIndex:0];
        [_overlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.headerView);
        }];
    }
    return _overlayImage;
}

@end
