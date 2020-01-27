//
//  FRMyProfileIconCell.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileIconCell.h"
#import "FRStyleKit.h"

@interface FRMyProfileIconCell ()

@property (nonatomic, strong) UIImageView* arrowImage;
@property (nonatomic, strong) UISwitch* switchView;
@property (nonatomic, strong) FRMyProfileIconCellViewModel* model;
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@end

static CGFloat const kHeightIcon = 32;

@implementation FRMyProfileIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self arrowImage];
        self.separatorInset = UIEdgeInsetsMake(-5, 0, 0, 15);
        [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if ((selected)&&([self.titleLabel.text isEqualToString:@"Mobile (hidden)"])) {
        [self.model presentAddMobileController];
    }
}

- (void)updateWithModel:(FRMyProfileIconCellViewModel*)model
{
    self.model = model;
    [self.switchView setOn:!model.isOpen];
    self.icon.image = model.icon;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    
    if ([model.title  isEqual: @"Available for a meetup?"]) {
        self.switchView.hidden = NO;
        self.arrowImage.hidden = YES;
        [self.subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImage.mas_left).offset(-30);
        }];
    }
    else
    {
        self.switchView.hidden = YES;
        self.arrowImage.hidden = NO;
    }
}

- (void)switchAction:(UISwitch*)sender
{
    NSInteger status = sender.isOn ? 0 : 1;
    
    [self.model changeStatus:status];
    
//    self.model.isOpen = sender.isOn;
//    NSString* result = [NSString new];
//    if (sender.isOn)
//    {
//        result = @"1";
//    }
//    else
//    {
//        result = @"0";
//    }
//    [FRUserManager sharedInstance].available_for_meet = sender.isOn;
}


#pragma mark - Lazy Load

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.layer.cornerRadius = 0;
        _icon.tintColor =  [UIColor blueColor];
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(kHeightIcon));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _icon;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_arrowImage];
        
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@20);
        }];
    }
    return _arrowImage;
}


- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(10);
            make.bottom.equalTo(self.icon.mas_centerY).offset(1);
            make.right.equalTo(self.arrowImage.mas_right).offset(-20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [[UIColor bs_colorWithHexString:@"606671"] colorWithAlphaComponent:0.4];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;

        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.icon.mas_centerY).offset(2);
            make.right.equalTo(self.titleLabel);
        }];
    }
    return _subtitleLabel;
}

- (UISwitch*)switchView
{
    if (!_switchView)
    {
        _switchView = [UISwitch new];
        _switchView.onTintColor = [UIColor bs_colorWithHexString:kPurpleColor];
        _switchView.backgroundColor = [UIColor bs_colorWithHexString:@"E7E8EC"];
        _switchView.layer.cornerRadius = 15.5;
        [self.contentView addSubview:_switchView];
        
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _switchView;
}




@end
