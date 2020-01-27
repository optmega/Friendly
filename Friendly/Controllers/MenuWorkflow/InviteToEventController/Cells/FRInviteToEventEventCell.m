//
//  FRInviteToEventEventCell.m
//  Friendly
//
//  Created by User on 29.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInviteToEventEventCell.h"
#import "FRMyEventsDateView.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"

@interface FRInviteToEventEventCell()

@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) FRMyEventsDateView* dateView;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* spotsLabel;
@property (strong, nonatomic) UIImageView* genderView;
@property (strong, nonatomic) UIImageView* eventPhotoView;
@property (assign, nonatomic) BOOL isCreateCell;

@end

@implementation FRInviteToEventEventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self separator];
        [self titleLabel];
        [self spotsLabel];
        [self genderView];
        [self eventPhotoView];
        [self dateView];
        [self _setGender:FRGenderTypeAll];
    }
    return self;
}

- (void) updateWithModel:(FREvent*)model
{
    self.titleLabel.text = model.title;
    self.isCreateCell = NO;
    self.separator.hidden = NO;
    self.genderView.hidden = NO;
    [self.spotsLabel setText:[NSString stringWithFormat:@"%lu spots left", [model.slots integerValue]-model.memberUsers.count]];
    [self _setGender:[model.gender integerValue]];
    NSURL* urlForHeader = [NSURL URLWithString:model.imageUrl];
    [self.eventPhotoView sd_setImageWithURL:urlForHeader completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image1)
        {
            self.eventPhotoView.image = image1;
            self.eventPhotoView.layer.cornerRadius = 15;
        }
    }];
    [_spotsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eventPhotoView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.dateView updateDateViewWithDate:model.event_start];
    self.dateView.hidden = NO;

    [self.contentView layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.isCreateCell) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else if (highlighted)
    {
        self.contentView.backgroundColor = [UIColor bs_colorWithHexString:@"#D5D9E0"];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void) updateToLastCell
{
    self.genderView.hidden = YES;
    self.titleLabel.text = @"New event";
    [self.spotsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(10);
    }];
    self.isCreateCell = YES;
    self.spotsLabel.text = @"Co-host an event with your friend";
    [self.eventPhotoView setImage:[FRStyleKit imageOfCreateneweventCanvas]];
    [self.eventPhotoView setBackgroundColor:[UIColor whiteColor]];
    self.eventPhotoView.layer.cornerRadius = 0;
    self.dateView.hidden = YES;
    self.separator.hidden = YES;
}

- (void)_setGender:(FRGenderType)gender
{
    switch (gender) {
        case FRGenderTypeAll: {
            self.genderView.image = [FRStyleKit imageOfSexBoth];
            break;
        }
        case FRGenderTypeMale: {
            self.genderView.image = [FRStyleKit imageOfSexMaleOnCanvas];
            
            break;
        }
        case FRGenderTypeFemale: {
            self.genderView.image = [FRStyleKit imageOfSexFemaleOnCanvas];
            
            break;
        }
    }
    [self.genderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.genderView.image.size.width / 2));
    }];
}


#pragma mark - LazyLoad

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UIImageView*) eventPhotoView
{
    if (!_eventPhotoView)
    {
        _eventPhotoView = [UIImageView new];
        _eventPhotoView.layer.cornerRadius = 15;
        _eventPhotoView.clipsToBounds = YES;
        [_eventPhotoView setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:_eventPhotoView];
        [_eventPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.height.width.equalTo(@100);
        }];
    }
    return _eventPhotoView;
}

- (FRMyEventsDateView*) dateView
{
    if (!_dateView)
    {
        _dateView = [FRMyEventsDateView new];
        _dateView.layer.cornerRadius = 10;
        _dateView.backgroundColor = [UIColor whiteColor];
        _dateView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _dateView.layer.borderWidth = 3;
        [_dateView.dayOfWeekLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateView).offset(8);
            make.centerX.equalTo(self.dateView);
        }];
        _dateView.dayOfWeekLabel.font = [UIFont boldSystemFontOfSize:12];
        _dateView.dayLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.eventPhotoView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@50);
            make.centerX.centerY.equalTo(self.eventPhotoView);
        }];
    }
    return _dateView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"Title"];
        _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(18);
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eventPhotoView.mas_right).offset(15);
            make.bottom.equalTo(self.spotsLabel.mas_top).offset(-3);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.lessThanOrEqualTo(@40);
        }];
    }
    return _titleLabel;
}

- (UILabel*) spotsLabel
{
    if (!_spotsLabel)
    {
        _spotsLabel = [UILabel new];
        [_spotsLabel setText:@"0 spots left"];
        _spotsLabel.font = FONT_PROXIMA_NOVA_REGULAR(14);
        _spotsLabel.adjustsFontSizeToFitWidth = YES;
        [_spotsLabel setTextColor:[UIColor bs_colorWithHexString:kTextSubtitleColor]];
        [self.contentView addSubview:_spotsLabel];
        [_spotsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eventPhotoView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return _spotsLabel;
}

- (UIImageView*) genderView
{
    if (!_genderView)
    {
        _genderView = [UIImageView new];
        _genderView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_genderView];
        [_genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eventPhotoView.mas_right).offset(15);
            make.top.equalTo(self.spotsLabel.mas_bottom).offset(3);
            make.height.equalTo(@25);
        }];
    }
    return _genderView;
}

@end
