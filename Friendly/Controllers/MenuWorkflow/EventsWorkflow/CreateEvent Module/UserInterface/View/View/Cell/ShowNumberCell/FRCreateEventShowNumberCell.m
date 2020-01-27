//
//  FRCreateEventShowNumberCell.m
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventShowNumberCell.h"


@interface FRCreateEventShowNumberCell ()

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UISwitch* switchView;

@property (nonatomic, strong) FRCreateEventShowNumberCellViewModel* model;

@end

@implementation FRCreateEventShowNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10);
        [self switchView];
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventShowNumberCellViewModel*)model
{
    self.model = model;
    self.icon.image = model.icon;
    self.switchView.selected = model.isSelected;
    self.titleLabel.text = model.title;
}

- (void)switchAction:(UISwitch*)sender
{
    self.model.isSelected = sender.isOn;
}

#pragma mark - Lazy Load

//- (UIImageView*)icon
//{
//    if (!_icon)
//    {
//        _icon = [UIImageView new];
//        [self.contentView addSubview:_icon];
//        
//        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@20);
//            make.left.equalTo(self.contentView).offset(20);
//            make.centerY.equalTo(self.titleLabel);
//        }];
//    }
//    return _icon;
//}
//
//- (UILabel*)titleLabel
//{
//    if (!_titleLabel)
//    {
//        _titleLabel = [UILabel new];
//        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
//        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
//        [self addSubview:_titleLabel];
//        
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(25);
//            make.left.equalTo(self.icon.mas_right).offset(20);
//        }];
//    }
//    return _titleLabel;
//}
//
//- (UISwitch*)switchView
//{
//    if (!_switchView)
//    {
//        _switchView = [UISwitch new];
//        _switchView.on = NO;
//        [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        _switchView.onTintColor = [UIColor bs_colorWithHexString:@"7340F2"];
//        _switchView.backgroundColor = [UIColor bs_colorWithHexString:@"E7E8EC"];
//        _switchView.layer.cornerRadius = 15.5;
//        [self addSubview:_switchView];
//        
//        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(20);
//            make.right.equalTo(self.contentView).offset(-20);
//        }];
//    }
//    return _switchView;
//}

@end
