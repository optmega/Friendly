//
//  FREventFilterSortByCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterSortByCell.h"

@interface FREventFilterSortByCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UISegmentedControl* segmentControl;
@property (nonatomic, strong) FREventFilterSortByCellViewModel* model;

@end

static CGFloat const kLeftOffset = 20;

@implementation FREventFilterSortByCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self titleLabel];
        [self segmentControl];
    }
    return self;
}

- (void)updateWithModel:(FREventFilterSortByCellViewModel*)model
{
    self.model = model;
    [self.segmentControl setSelectedSegmentIndex:model.segmentSelectedIndex];
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        _titleLabel.text = FRLocalizedString(@"SORT BY", nil);
        _titleLabel.font = FONT_SF_DISPLAY_BOLD(11);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kLeftOffset);
            make.top.equalTo(self.contentView).offset(18);
        }];
    }
    return _titleLabel;
}

- (void)segmentAction:(UISegmentedControl*)sender
{
    self.model.segmentSelectedIndex = sender.selectedSegmentIndex;
}

- (UISegmentedControl*)segmentControl
{
    if (!_segmentControl)
    {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Newest", @"Date"]];
        [_segmentControl setTintColor:[UIColor bs_colorWithHexString:kPurpleColor]];

        UIFont *font = FONT_SF_DISPLAY_MEDIUM(15);
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [_segmentControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:_segmentControl];
        [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(22.5);
            make.right.equalTo(self.contentView).offset(-22.5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(19);
            make.height.equalTo(@36);
        }];
    }
    return _segmentControl;
}



@end
