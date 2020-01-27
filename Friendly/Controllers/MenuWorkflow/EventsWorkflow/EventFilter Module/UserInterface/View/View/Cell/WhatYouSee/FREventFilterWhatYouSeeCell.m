//
//  FREventFilterWhatYouSeeCell.m
//  Friendly
//
//  Created by D on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterWhatYouSeeCell.h"

@interface FREventFilterWhatYouSeeCell()

@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UILabel* titleLabel;

@end


@implementation FREventFilterWhatYouSeeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self titleLabel];
    }
    
    return self;
}

- (void)updateWithModel:(id)model
{
    
}


- (UIView*)topView
{
    if (!_topView)
    {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@10);
        }];
    }
    return _topView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = FRLocalizedString(@"WHAT YOU SEE", nil);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        _titleLabel.font = FONT_SF_DISPLAY_BOLD(11);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.topView.mas_bottom).offset(18);
        }];
    }
    return _titleLabel;
}


@end
