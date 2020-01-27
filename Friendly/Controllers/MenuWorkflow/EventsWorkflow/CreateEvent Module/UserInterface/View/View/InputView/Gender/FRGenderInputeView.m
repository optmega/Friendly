//
//  FRGenderInputeView.m
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGenderInputeView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRGenderInputeView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UIButton* bothSexButton;
@property (nonatomic, strong) UIButton* maleButton;
@property (nonatomic, strong) UIButton* femaleButton;

@property (nonatomic, strong) NSArray* buttons;
@property (nonatomic, assign) FRGenderType typeGender;

@end

@implementation FRGenderInputeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel];
        self.buttons = @[self.bothSexButton, self.femaleButton, self.maleButton];
        [self.maleButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        [self.femaleButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        [self.bothSexButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bothSexButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)setGender:(FRGenderType)type
{
    switch (type) {
        case FRGenderTypeAll:
        {
            [self.bothSexButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        } break;
        case FRGenderTypeMale:
        {
            [self.maleButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        } break;
        case FRGenderTypeFemale:
        {
            [self.femaleButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        } break;
            
        default:
            break;
    }
}

- (void)doneAction:(UIButton*)sender
{
    [self.delegate selectedGender:self.typeGender];
}

- (void)closeSelected
{
    [self.delegate closeSelected];
}

- (void)selectGender:(UIButton*)sender
{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //obj.selected = NO;
    }];
 //   sender.selected = YES;
    if ([sender isEqual:self.maleButton])
    {
        [self.maleButton setImage:[FRStyleKit imageOfSexMaleOnCanvas] forState:UIControlStateNormal];
        [self.maleButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateNormal];
            [_bothSexButton setImage:[FRStyleKit imageOfSexBothOffCanvas] forState:UIControlStateNormal];
        [_bothSexButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
          [_femaleButton setImage:[FRStyleKit imageOfSexFamaleOffCanvas] forState:UIControlStateNormal];
        [_femaleButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];

        
    }
    if ([sender isEqual:self.femaleButton])
    {
       [_maleButton setImage:[FRStyleKit imageOfSexMaleOffCanvas] forState:UIControlStateNormal];
        [_maleButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
        [self.femaleButton setImage:[FRStyleKit imageOfSexFemaleOnCanvas] forState:UIControlStateNormal];
        [self.femaleButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateNormal];
            [_bothSexButton setImage:[FRStyleKit imageOfSexBothOffCanvas] forState:UIControlStateNormal];
        [_bothSexButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
    }
    if ([sender isEqual:self.bothSexButton])
    {
       [_maleButton setImage:[FRStyleKit imageOfSexMaleOffCanvas] forState:UIControlStateNormal];
        [_maleButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
         [self.bothSexButton setImage:[FRStyleKit imageOfSexBothOnCanvas] forState:UIControlStateNormal];
        [self.bothSexButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateNormal];
          [_femaleButton setImage:[FRStyleKit imageOfSexFamaleOffCanvas] forState:UIControlStateNormal];
        [_femaleButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];

    }
    self.typeGender = sender.tag;
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.text = FRLocalizedString(@"Gender select", nil);
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.headerView);
        }];
    }
    return _titleLabel;
}

- (UIView*)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom).offset(0);
            make.bottom.equalTo(self.cancelButton.mas_top).offset(0);
        }];
    }
    return _contentView;
}


- (UIButton*)bothSexButton
{
    if (!_bothSexButton)
    {
        _bothSexButton = [UIButton new];
        [_bothSexButton setTitle:FRLocalizedString(@"Guys & girls", nil) forState:UIControlStateNormal];
        _bothSexButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);

        [_bothSexButton setImage:[FRStyleKit imageOfSexBothOnCanvas] forState:UIControlStateSelected];
        [_bothSexButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateSelected];
        [_bothSexButton setImage:[FRStyleKit imageOfSexBothOnCanvas] forState:UIControlStateHighlighted];
        
        [_bothSexButton setImage:[UIImageHelper imageByApplyingAlpha:[FRStyleKit imageOfSexBothOffCanvas] alpha:0.8] forState:UIControlStateHighlighted];
        
        [_bothSexButton setImage:[FRStyleKit imageOfSexBothOffCanvas] forState:UIControlStateNormal];
        [_bothSexButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
        
        _bothSexButton.tag = FRGenderTypeAll;
        
        [_bothSexButton setTitleEdgeInsets:UIEdgeInsetsMake(70, - 90, 0, 0)];
        [self.contentView addSubview:_bothSexButton];
        
        [_bothSexButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
            make.width.equalTo(@90);
            make.left.equalTo(self.femaleButton.mas_right).offset(30);
        }];
    }
    return _bothSexButton;
}

- (UIButton*)maleButton
{
    if (!_maleButton)
    {
        _maleButton = [UIButton new];
        [_maleButton setTitle:FRLocalizedString(@"Guys only", nil) forState:UIControlStateNormal];
        _maleButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        
//        [_maleButton setImage:[FRStyleKit imageOfSexMaleOnCanvas] forState:UIControlStateSelected];
//        [_maleButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateSelected];

        [_maleButton setImage:[UIImageHelper imageByApplyingAlpha:[FRStyleKit imageOfSexMaleOffCanvas] alpha:0.8] forState:UIControlStateHighlighted];
        
        [_maleButton setImage:[FRStyleKit imageOfSexMaleOffCanvas] forState:UIControlStateNormal];
        [_maleButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
        
        _maleButton.tag = FRGenderTypeMale;
        
        [_maleButton setTitleEdgeInsets:UIEdgeInsetsMake(70, - 60, 0, 0)];
        [self.contentView addSubview:_maleButton];
        
        [_maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
            make.right.equalTo(self.femaleButton.mas_left).offset(-30);
            make.width.equalTo(@60);
        }];
    }
    return _maleButton;
}

- (UIButton*)femaleButton
{
    if (!_femaleButton)
    {
        _femaleButton = [UIButton new];
        [_femaleButton setTitle:FRLocalizedString(@"Girls only", nil) forState:UIControlStateNormal];
        _femaleButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _femaleButton.tag = FRGenderTypeFemale;
        
        [_femaleButton setImage:[FRStyleKit imageOfSexFemaleOnCanvas] forState:UIControlStateSelected];
        [_femaleButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateSelected];
        
        [_femaleButton setTintColor:nil];
        [_femaleButton setImage:[UIImageHelper imageByApplyingAlpha:[FRStyleKit imageOfSexFamaleOffCanvas] alpha:0.8] forState:UIControlStateHighlighted];
        
        [_femaleButton setImage:[FRStyleKit imageOfSexFamaleOffCanvas] forState:UIControlStateNormal];
        [_femaleButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];
        
        
        [_femaleButton setTitleEdgeInsets:UIEdgeInsetsMake(70, - 60, 0, 0)];
        [self.contentView addSubview:_femaleButton];
        
        [_femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-14);
            make.width.equalTo(@60);
            make.centerX.equalTo(self.contentView).offset(-10);
            
        }];
    }
    return _femaleButton;
}


@end

