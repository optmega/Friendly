//
//  FRProfileShareInstagramCell.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileShareInstagramCell.h"
#import "FRStyleKit.h"

@interface FRProfileShareInstagramCell ()

@property (nonatomic, strong) FRProfileShareInstagramCellViewModel* model;

@end

@implementation FRProfileShareInstagramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        @weakify(self);
        [[self.connectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model connectSelected];
        }];
    }
    return self;
}

- (void)updateWithModel:(FRProfileShareInstagramCellViewModel*)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.connectButton.mas_left).offset(-20);
            make.top.equalTo(self.contentView).offset(19);
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
        _subtitleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.connectButton.mas_left).offset(-15);
        }];
    }
    return _subtitleLabel;
}

- (UIButton*)connectButton
{
    if (!_connectButton)
    {
        _connectButton = [UIButton new];
        _connectButton.backgroundColor = [UIColor bs_colorWithHexString:@"#FF6868"];
        [_connectButton setImage:[FRStyleKit imageOfInstagramCanvas] forState:UIControlStateNormal];
        _connectButton.titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(14);
        [_connectButton setTitle:@" Connect" forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _connectButton.layer.cornerRadius = 5;
        [self.contentView addSubview:_connectButton];
        
        [_connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.width.equalTo(@102);
            make.bottom.equalTo(self.subtitleLabel);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _connectButton;
}

@end
