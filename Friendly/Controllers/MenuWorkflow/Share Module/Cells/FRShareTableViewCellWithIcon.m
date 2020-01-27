//
//  FRShareTableViewCellWithIcon.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRShareTableViewCellWithIcon.h"
#import "FRStyleKit.h"

@interface FRShareTableViewCellWithIcon()

@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIImageView* arrowIcon;
@property (strong, nonatomic) UILabel* headerLabel;
@property (strong, nonatomic) UIButton* cellButton;

@end

@implementation FRShareTableViewCellWithIcon

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self separator];
        [self arrowIcon];
        [self headerLabel];
        [self cellButton];
    }
    return self;
}

-(void)updateWithHeader:(NSString*)headerText cellText:(NSString*)cellText andIcon:(UIImage*)icon
{
    self.headerLabel.text = headerText;
    [self.cellButton setTitle:cellText forState:UIControlStateNormal];
    [self.cellButton setImage:icon forState:UIControlStateNormal];
}

-(void) showVC
{
    if ([self.cellButton.titleLabel.text isEqualToString:@"Text it to a friend"])
    {
        [self.delegate showSendToVC];
    }
    if ([self.cellButton.titleLabel.text isEqualToString:@"Post to your wall"])
    {
        [self.delegate showPostToVC];
    }
    if ([self.cellButton.titleLabel.text isEqualToString:@"Select people"])
    {
        [self.delegate showSelectPeopleVC];
    }
    if ([self.cellButton.titleLabel.text isEqualToString:@"Message"])
    {
        [self.delegate showSendMessageVC];
    }

}


#pragma mark - LazyLoad

-(UILabel*) headerLabel
{
    if (!_headerLabel)
    {
        _headerLabel = [UILabel new];
        [_headerLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(14)];
        [_headerLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self.contentView addSubview:_headerLabel];
        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(34);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _headerLabel;
}

-(UIButton*) cellButton
{
    if (!_cellButton)
    {
        _cellButton = [UIButton new];
        [_cellButton setImage:[FRStyleKit imageOfActionBarAddUser] forState:UIControlStateNormal];
        _cellButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cellButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_cellButton addTarget:self action:@selector(showVC) forControlEvents:UIControlEventTouchUpInside];
        [_cellButton setTitle:@"Post to" forState:UIControlStateNormal];
        [_cellButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_cellButton.titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(17)];
        [_cellButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateNormal];
        [self.contentView addSubview:_cellButton];
        [_cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.headerLabel.mas_bottom);
            make.height.equalTo(@55);
        }];
    }
    return _cellButton;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.cellButton addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.cellButton);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UIImageView*)arrowIcon
{
    if (!_arrowIcon) {
        _arrowIcon = [UIImageView new];
        [_arrowIcon setImage:[FRStyleKit imageOfFeildChevroneCanvas]];
        [self.contentView addSubview:_arrowIcon];
        [_arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.cellButton);
        }];
    }
    return _arrowIcon;
}

@end
