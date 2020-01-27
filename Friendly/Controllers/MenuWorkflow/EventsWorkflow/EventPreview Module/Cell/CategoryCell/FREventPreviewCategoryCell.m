//
//  FRCategoryTableViewCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewCategoryCell.h"
#import "FRStyleKitCategory.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FREventPreviewCategoryCell()

@property (strong, nonatomic) UIImageView* backView;
@property (strong, nonatomic) UILabel* text;
@property (strong, nonatomic) UILabel* categoryName;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIImageView* arrow;
@property (strong, nonatomic) NSArray* categoryIconsArray;
@property (strong, nonatomic) NSArray* categoryBackgroundsArray;

@end

@implementation FREventPreviewCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self backView];
        [self text];
        [self icon];
//        [self categoryName];
//        [self separator];
        [self arrow];
    }
    return self;
}

- (void) updateWithModel:(FREventPreviewCategoryCellViewModel*)model countNearbyEvents:(NSString *)count;
{
    self.categoryName.text = model.category;
    if ([model.category isEqual: @"Dining"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - food"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIcondinningCanvas]];
    }
    if ([model.category isEqual: @"Nightlife"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - nightlife"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconnightlifeCanvas]];
    }
    if ([model.category isEqual: @"Fun"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - fun"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconfunCanvas]];
    }
    if ([model.category isEqual: @"Travel"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - travel"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIcontravelCanvas]];
    }
    if ([model.category isEqual: @"Fitness"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - fitness"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconfitnessCanvas]];
    }
    if ([model.category isEqual: @"Pets"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - pets"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconpetsCanvas]];
    }
    if ([model.category isEqual: @"Outdoors"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - outdoors"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconoutdoorsCanvas]];
    }
    if ([model.category isEqual: @"Gay"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - gay"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIcongayCanvas]];
    }
    if ([model.category isEqual: @"Community"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - community"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconcommunityCanvas]];
    }
    if ([model.category isEqual: @"Other"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - other"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconotherCanvas]];
    }
    if ([model.category isEqual: @"All"])
    {
        [self.backView setImage:[UIImage imageNamed:@"Cateogorie - Large - other"]];
        [self.icon setImage:[FRStyleKitCategory imageOfIconotherCanvas]];
    }
    
    BOOL isHaveCount = !([count isEqualToString:@""] || count == nil || [count isEqualToString:@"0"]);
    NSString *countStr = !isHaveCount ? @"There's no " : [NSString stringWithFormat:@"%@ more ", count];
    
    [self.text setText:[NSString stringWithFormat:@"%@nearby events\nin '%@' category", countStr, model.category]];
}

#pragma mark - LazyLoad

-(UIImageView*) backView
{
    if (!_backView)
    {
        _backView = [UIImageView new];
        [_backView setBackgroundColor:[UIColor clearColor]];
        [_backView setImage:[UIImage imageNamed:@"Categorie - Large - Other"]];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.height.equalTo(@110);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
    }
    return _backView;
}

-(UIImageView*) icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        [_icon setImage:[FRStyleKitCategory imageOfCategorieOtherCanvas]];
        [_icon setBackgroundColor:[UIColor clearColor]];
        [self.backView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).offset(25);
            make.centerY.equalTo(self.backView);
            make.width.height.equalTo(@65);
        }];
    }
    return _icon;
}
//
//-(UILabel*) categoryName
//{
//    if (!_categoryName)
//    {
//        _categoryName = [UILabel new];
//        _categoryName.textColor = [UIColor whiteColor];
//        _categoryName.font = FONT_CUSTOM_BOLD_SIZE(25);
//        [self.backView addSubview:_categoryName];
//        [_categoryName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.icon);
//            make.top.equalTo(self.icon.mas_bottom).offset(5);
//        }];
//    }
//    return _categoryName;
//}
//-(UIView*) separator
//{
//    if (!_separator)
//    {
//    _separator = [UIView new];
//    _separator.layer.cornerRadius = 2;
//    _separator.backgroundColor = [[UIColor bs_colorWithHexString:@"E6E8EC"]colorWithAlphaComponent:0.5f];
//    [self.backView addSubview:_separator];
//    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.icon).offset(5);
//        make.centerY.equalTo(self.backView);
//        make.left.equalTo(self.icon.mas_right).offset(20);
//        make.width.equalTo(@2);
//    }];
//    }
//    return _separator;
//
//}

-(UILabel*) text
{
    if (!_text)
    {
        _text = [UILabel new];
        [_text setTextColor:[UIColor whiteColor]];
        [_text setText:@"nearby events\nin this category"];
        [_text setFont:FONT_SF_DISPLAY_MEDIUM(16)];
        _text.adjustsFontSizeToFitWidth = YES;
        _text.numberOfLines = 0;
        [_text sizeToFit];
        [self.backView addSubview:_text];
        [_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(20);
            make.right.equalTo(self.arrow.mas_left).offset(5);
            make.centerY.equalTo(self.backView);
        }];
    }
    return _text;
}

-(UIImageView*) arrow
{
    if (!_arrow)
    {
        _arrow = [UIImageView new];
        [_arrow setBackgroundColor:[UIColor clearColor]];
        [_arrow setImage:[UIImageHelper image:[FRStyleKit imageOfFeildChevroneCanvas] color:[UIColor whiteColor]]];
        [self.backView addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-15);
            make.height.width.equalTo(@25);
            make.centerY.equalTo(self.backView);
        }];
    }
    return _arrow;
}

@end

