//
//  FRSearchViewControllerRelatedCategoryCell.m
//  Friendly
//
//  Created by Jane Doe on 4/21/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerRelatedCategoryCell.h"
#import "UIImageHelper.h"
#import "FRStyleKitCategory.h"
#import "FRStyleKit.h"
#import "FRCategoryManager.h"

@interface FRSearchViewControllerRelatedCategoryCell()

@property (strong, nonatomic) UIImageView* backImageView;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIImageView* iconImageView;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIImageView* arrowImageView;
@property (nonatomic, copy) NSString *category;

@end

@implementation FRSearchViewControllerRelatedCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self backImageView];
        [self titleLabel];
        [self iconImageView];
        [self separator];
        [self arrowImageView];
    }
    return self; 
}

-(void)updateWithId:(NSString*)category_id andCounter:(NSString*)count
{
    NSInteger indexOfCategory = [[[FRCategoryManager getCategoryDictionary] allValues] indexOfObject:category_id];
    
    NSString *category = [[FRCategoryManager getCategoryDictionary] allKeys][indexOfCategory];
    self.category = category;
    
    BOOL isHaveCount = !([count isEqualToString:@""] || count == nil || [count isEqualToString:@"0"]);
    NSString *countStr = !isHaveCount ? @"There's no " : [NSString stringWithFormat:@"%@ more ", count];
    
    [self.titleLabel setText:[NSString stringWithFormat:@"%@nearby events\nin '%@' category", countStr, category]];

    if ([category isEqualToString:@"Dining"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - food"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIcondinningCanvas]];
    }
    if ([category isEqualToString:@"Nightlife"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - nightlife"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconnightlifeCanvas]];
    }
    if ([category isEqualToString:@"Fun"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - fun"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconfunCanvas]];
    }
    if ([category isEqualToString:@"Travel"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - travel"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIcontravelCanvas]];
    }
    if ([category isEqualToString:@"Fitness"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - fitness"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconfitnessCanvas]];
    }
    if ([category isEqualToString:@"Pets"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - pets"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconpetsCanvas]];
    }
    if ([category isEqualToString:@"Outdoors"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - outdoors"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconoutdoorsCanvas]];
    }
    if ([category isEqualToString:@"Gay"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - gay"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIcongayCanvas]];
    }
    if ([category isEqualToString:@"Community"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - community"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconcommunityCanvas]];
    }
    if ([category isEqualToString:@"Other"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - other"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconotherCanvas]];
    }
    if ([category isEqualToString:@"All"])
    {
        [self.backImageView setImage:[UIImage imageNamed:@"Cateogorie - Large - other"]];
        [self.iconImageView setImage:[FRStyleKitCategory imageOfIconotherCanvas]];
    }
}


#pragma mark - LazyLoad

-(UIImageView*) backImageView
{
    if (!_backImageView)
    {
        _backImageView = [UIImageView new];
        [_backImageView setBackgroundColor:[UIColor clearColor]];
        [_backImageView setImage:[UIImage imageNamed:@"Categorie - Large - Other"]];
        [self.contentView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.height.equalTo(@110);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return _backImageView;
}

-(UIImageView*) iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        [_iconImageView setImage:[FRStyleKitCategory imageOfCategorieOtherCanvas]];
        [_iconImageView setBackgroundColor:[UIColor clearColor]];
        [self.backImageView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backImageView).offset(25);
            make.centerY.equalTo(self.backImageView);
            make.width.height.equalTo(@65);
        }];
    }
    return _iconImageView;
}



- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:@"nearby events\nin this category"];
        [_titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(16)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        [self.backImageView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(20);
            make.right.equalTo(self.arrowImageView.mas_left).offset(5);
            make.centerY.equalTo(self.backImageView);
        }];
    }
    return _titleLabel;
}

- (UIImageView*)arrowImageView
{
    if (!_arrowImageView)
    {
        _arrowImageView = [UIImageView new];
        [_arrowImageView setBackgroundColor:[UIColor clearColor]];
        [_arrowImageView setImage:[UIImageHelper image:[FRStyleKit imageOfFeildChevroneCanvas] color:[UIColor whiteColor]]];
        [self.backImageView addSubview:_arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backImageView).offset(-15);
            make.height.width.equalTo(@25);
            make.centerY.equalTo(self.backImageView);
        }];
    }
    return _arrowImageView;
}



@end
