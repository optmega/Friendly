//
//  FRProfileTextFieldCell.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileTextViewCell.h"
#import "UITextView+Placeholder.h"
#import "UITextField+RACKeyboardSupport.h"
#import "UITextfieldHelper.h"
#import "FRStyleKit.h"

#define ACCEPTABLE_CHARACTERS @" абвгдеёжзйиклмнопрстуфхцчшщъьыэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,"

@interface FRProfileTextViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextView* subtitleTextView;
@property (nonatomic, strong) FRProfileTextViewCellViewModel* model;
@property (nonatomic, strong) UIImageView* requiredLabel;
@property (nonatomic, strong) UILabel* maxRangeLabel;

@end

@implementation FRProfileTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.subtitleTextView.delegate = self;
        
    }
    return self;
}


- (void)updateWithModel:(FRProfileTextViewCellViewModel*)model
{
    self.contentView.hidden = model.isHideMode;
    self.model = model;
    self.titleLabel.text = model.title;
    self.subtitleTextView.placeholder = model.subtitle;
    self.subtitleTextView.text = model.dataString;
    
    self.requiredLabel.hidden = !model.isRequiredField;
    self.maxRangeLabel.hidden = !model.isRequiredField;
    self.maxRangeLabel.text = [NSString stringWithFormat:@"%ld", (long)model.countCharacter];
    if (model.keyType == FRProfileTextViewKeyTypeText)
    {
        self.subtitleTextView.keyboardType = UIKeyboardTypeDefault;
        self.subtitleTextView.inputAccessoryView = nil;
    }
    else
    {
        self.subtitleTextView.keyboardType = UIKeyboardTypeNumberPad;
        UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.translucent = YES;
        toolbar.tintColor = [UIColor whiteColor];
        UIButton* doneButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 36)];
        [doneButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        doneButton.layer.cornerRadius = 5;
        doneButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        doneButton.layer.borderWidth = 1;
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        UIBarButtonItem* flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        
        [toolbar setItems:@[flexItem, doneItem]];
        self.subtitleTextView.inputAccessoryView = toolbar;
    }
    
}

- (void)doneAction:(id)sender
{
    [self.subtitleTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textView.text, text];
    
    if (self.model.keyType == FRProfileTextViewKeyTypeNumber)
    {
        if (range.length == 1){
            textView.text = [UITextfieldHelper formatPhoneNumber:totalString deleteLastChar:YES];
            
        } else {
            textView.text = [UITextfieldHelper formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        
        self.model.dataString = textView.text;
        
        return false;
    }
    if (self.model.isInterestCell)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [text isEqualToString:filtered];
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.delegate textEditing:self :textView];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > self.model.maxCountCharacter)
    {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, self.model.maxCountCharacter)];
        
        self.model.dataString = textView.text;
        self.model.countCharacter = self.model.maxCountCharacter - textView.text.length;
        self.maxRangeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.model.countCharacter];
        
        [self.delegate textChangeWithCell:self];
        return;
    }
    
    
    self.model.dataString = textView.text;
    self.model.countCharacter = self.model.maxCountCharacter - textView.text.length;
    self.maxRangeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.model.countCharacter];
    
    [self.delegate textChangeWithCell:self];
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return _titleLabel;
}

- (UITextView*)subtitleTextView
{
    if (!_subtitleTextView)
    {
        _subtitleTextView = [UITextView new];
        _subtitleTextView.textColor = [UIColor bs_colorWithHexString:KTextTitleColor];
        _subtitleTextView.font = FONT_SF_DISPLAY_REGULAR(17);
        _subtitleTextView.textContainerInset = UIEdgeInsetsZero;
        _subtitleTextView.scrollEnabled = NO;
//        _subtitleTextView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _subtitleTextView.textContainer.lineFragmentPadding = 0;
    
        [self.contentView addSubview:_subtitleTextView];
        
        [_subtitleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(45);
            make.bottom.equalTo(self.contentView).offset(-29);
        }];
    }
    return _subtitleTextView;
}

- (UIImageView*)requiredLabel
{
    if (!_requiredLabel)
    {
        _requiredLabel = [UIImageView new];
//        _requiredLabel.text = @"*";
//        _requiredLabel.font = FONT_SF_DISPLAY_REGULAR(17);
//        _requiredLabel.backgroundColor = [UIColor lightGrayColor];
        [_requiredLabel setImage:[FRStyleKit imageOfRedtick]];
        _requiredLabel.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_requiredLabel];
        
        [_requiredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.centerY.equalTo(self.titleLabel).offset(-1);
            make.width.height.equalTo(@10);
        }];
    }
    return _requiredLabel;
}

- (UILabel*)maxRangeLabel
{
    if (!_maxRangeLabel)
    {
        _maxRangeLabel = [UILabel new];
        _maxRangeLabel.textColor = [UIColor redColor];
        _maxRangeLabel.font = FONT_SF_TEXT_REGULAR(14);
        _maxRangeLabel.text = @"200";
        
        [self.contentView addSubview:_maxRangeLabel];
        
        [_maxRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return _maxRangeLabel;
}

@end
