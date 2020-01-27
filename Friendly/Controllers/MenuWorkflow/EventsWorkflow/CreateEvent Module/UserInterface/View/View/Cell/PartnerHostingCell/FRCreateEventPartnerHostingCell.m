//
//  FRCreateEventPartnerHostingCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventPartnerHostingCell.h"
#import "FRStyleKit.h"
#import "CMPopTipView.h"

@interface FRCreateEventPartnerHostingCell () <CMPopTipViewDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UILabel* contentTitleLabel;
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) FRCreateEventPartnerHostingCellViewModel* model;
@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) UIView* createView;
@property (nonatomic, strong) UIView* targetView;
@property (nonatomic, strong) UIView* sep;
@end

@implementation FRCreateEventPartnerHostingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self titleLabel];
        [self subtitleLabel];
        [self icon];
        [self separator];
        self.createView = [UIView new];
        [self.contentView addSubview:self.createView];
        [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.height.width.equalTo(@1);
        }];
        [self sep];
        self.contentView.clipsToBounds = false;
        self.clipsToBounds = false;

    }
    return self;
}

- (UIView*)sep
{
    if (!_sep)
    {
        _sep = [UIView new];
        _sep.backgroundColor = [UIColor bs_colorWithHexString:@"E1E4ED"];
        [self.contentView addSubview:_sep];
        [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.equalTo(@(0.5));
        }];
    }
    return _sep;
}

- (UIView*)targetView {
    if (!_targetView) {
        _targetView = [[UIView alloc] initWithFrame:CGRectMake(40, 55, 1, 1)];
        [self.contentView addSubview:_targetView];
    }
    
    return _targetView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CohostPopView"]) {
        
        self.searchHelperView.hidden = true;
    } else {
        self.searchHelperView.hidden = false;
    }

}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [[NSUserDefaults standardUserDefaults] setObject:@"hide" forKey:@"CohostPopView"];
}

- (CMPopTipView*)searchHelperView
{
    if (!_searchHelperView)
    {
        _searchHelperView = [[CMPopTipView alloc] initWithTitle:nil message:@"Hosting event's is more fun with a friend"];
        _searchHelperView.pointerSize = 5;
        _searchHelperView.cornerRadius = 5;
        _searchHelperView.delegate = self;
        _searchHelperView.has3DStyle = false;
        _searchHelperView.textFont = FONT_PROXIMA_NOVA_MEDIUM(15);
        _searchHelperView.textColor = [UIColor whiteColor];
        _searchHelperView.hasGradientBackground = false;
        _searchHelperView.maxWidth = 300;
        _searchHelperView.borderColor = [UIColor clearColor];
        _searchHelperView.backgroundColor = [UIColor bs_colorWithHexString:@"00B5FF"];
        _searchHelperView.bubblePaddingY = 8;
        _searchHelperView.bubblePaddingX = 15;
        _searchHelperView.preferredPointDirection = PointDirectionUp;
        _searchHelperView.sidePadding = 10;
        [_searchHelperView presentPointingAtView:self.targetView inView:self.contentView animated:true];
    }
    return _searchHelperView;
}

- (void)updateWithModel:(FRCreateEventPartnerHostingCellViewModel*)model
{
    self.model = model;
    self.contentTitleLabel.text = model.contentTitle;
}

#pragma mark - Lazy Load

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return _separator;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.text = FRLocalizedString(@"Partner hosting", nil);
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
        _subtitleLabel.text = FRLocalizedString(@"Invite a friend to co-host", nil);

        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }
    return _subtitleLabel;
}

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _icon;
}

- (UILabel*)contentTitleLabel
{
    if (!_contentTitleLabel)
    {
        _contentTitleLabel = [UILabel new];
//        _contentTitleLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
//        _contentTitleLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        
        
        _contentTitleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _contentTitleLabel.textAlignment = NSTextAlignmentRight;
        _contentTitleLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
        _contentTitleLabel.adjustsFontSizeToFitWidth = YES;


        [self.contentView addSubview:_contentTitleLabel];
        [_contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.icon.mas_left).offset(-5);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _contentTitleLabel;
}


@end
