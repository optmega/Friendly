//
//  FRCreateEventOpenToFBCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventOpenToFBCell.h"
#import "CMPopTipView.h"

@interface FRCreateEventOpenToFBCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UISwitch* switchView;
@property (nonatomic, strong) CMPopTipView* tooltipView;
@property (nonatomic, strong) FRCreateEventOpenToFBCellViewModel* model;
@property (nonatomic, strong) UIView* createView;

@end

@implementation FRCreateEventOpenToFBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self titleLabel];
        [self subtitleLabel];
        [self tooltipView];
        self.createView = [UIView new];
        [self.contentView addSubview:self.createView];
        [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.height.width.equalTo(@1);
        }];

        [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventOpenToFBCellViewModel*)model
{
    self.model = model;
    [self.switchView setOn:model.isOpen];
}

- (void)switchAction:(UISwitch*)sender
{
    self.model.isOpen = sender.isOn;
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.text = FRLocalizedString(@"Open to guests friends", nil);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        _subtitleLabel.text = FRLocalizedString(@"Allow guests to invite their fb friends", nil);
        
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
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
        _switchView.backgroundColor = [UIColor bs_colorWithHexString:@"#D5D9E1"];
        _switchView.thumbTintColor = [UIColor whiteColor];
        _switchView.tintColor =  [UIColor bs_colorWithHexString:@"#D5D9E1"];
        _switchView.layer.cornerRadius = 15.5;
        [self.contentView addSubview:_switchView];
        
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _switchView;
}
//
//- (CMPopTipView*)tooltipView
//{
//    if (!_tooltipView)
//    {
//        _tooltipView = [[CMPopTipView alloc] initWithTitle:nil message:@"    Hosting events is more fun with a friend  "];
//        _tooltipView.pointerSize = 5;
//        _tooltipView.cornerRadius = 5;
//        _tooltipView.has3DStyle = false;
//        _tooltipView.textFont = FONT_PROXIMA_NOVA_MEDIUM(15);
//        _tooltipView.textColor = [UIColor whiteColor];
//        _tooltipView.hasGradientBackground = false;
//        _tooltipView.maxWidth = 340;
//        _tooltipView.borderColor = [UIColor clearColor];
//        _tooltipView.backgroundColor = [UIColor bs_colorWithHexString:@"00B5FF"];
//        _tooltipView.bubblePaddingY = 10;
//        _tooltipView.preferredPointDirection = PointDirectionUp;
//        [_tooltipView presentPointingAtView:self.createView inView:self.contentView animated:true];
//    }
//    return _tooltipView;
//}

@end
