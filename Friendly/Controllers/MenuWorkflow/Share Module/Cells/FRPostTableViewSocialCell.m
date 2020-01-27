//
//  FRPostTableViewSocialCell.m
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPostTableViewSocialCell.h"

@interface FRPostTableViewSocialCell()

@property (strong, nonatomic) UILabel* cellLabel;
@property (strong, nonatomic) UIButton* fbButton;
@property (strong, nonatomic) UIButton* twitterButton;
@property (strong, nonatomic) UIButton* tumblrButton;

@end

@implementation FRPostTableViewSocialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self cellLabel];
        [self fbButton];
        [self twitterButton];
        [self tumblrButton];
    }
    return self;
}


#pragma mark - LazyLoad

-(UILabel*) cellLabel
{
    if (!_cellLabel)
    {
        _cellLabel = [UILabel new];
        [_cellLabel setText:@"POST TO YOUR WALL"];
        [_cellLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(14)];
        [_cellLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self.contentView addSubview:_cellLabel];
        [_cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView).offset(10);
        }];
    }
    return _cellLabel;
}

@end
