//
//  FRPrivateAccountCell.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateAccountCell.h"

@interface FRPrivateAccountCell()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UISwitch* switchView;
@property (nonatomic, strong) FRPrivateAccountCellViewModel* model;

@end

@implementation FRPrivateAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setPreservesSuperviewLayoutMargins:NO];
        [self setLayoutMargins:UIEdgeInsetsZero];
        
        [self switchView];
        [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)updateWithModel:(FRPrivateAccountCellViewModel*)model
{
    if (!model.title) {
        self.switchView.hidden = YES;
    }
    [self.switchView setOn:model.isPrivateAccount animated:NO];
    self.model = model;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    
    if (model.isFullSeparator)
    {
         [self setSeparatorInset:UIEdgeInsetsZero];
    }
    else
    {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
}

- (void)switchAction:(UISwitch*)sender
{
    self.model.isPrivateAccount = sender.isOn;
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.switchView.mas_left).offset(20);
//            make.top.equalTo(self.contentView).offset(19);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
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
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_centerY).offset(16);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.switchView.mas_left).offset(-40);
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
        _switchView.backgroundColor = [UIColor bs_colorWithHexString:@"D5D9E1"];
        _switchView.thumbTintColor = [UIColor whiteColor];
        _switchView.layer.cornerRadius = 16.0;
        _switchView.tintColor = [UIColor bs_colorWithHexString:@"#D5D9E1"];
        [self.contentView addSubview:_switchView];
        
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _switchView;
}
@end
