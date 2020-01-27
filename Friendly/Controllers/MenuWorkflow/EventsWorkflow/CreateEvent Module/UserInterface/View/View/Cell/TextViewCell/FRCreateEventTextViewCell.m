//
//  FRCreateEventTextViewCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventTextViewCell.h"
#import "UITextView+Placeholder.h"
#import "FRCreateEventViewConstants.h"

#define ACCEPTABLE_CHARACTERS @" абвгдеёжзийклмнопрстуфхцчшщъьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.?!,"


@interface FRCreateEventTextViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) FRCreateEventTextViewCellViewModel* model;
@property (nonatomic, strong) UILabel* rangeLabel;
@property (nonatomic, strong) NSString* type;

@end

@implementation FRCreateEventTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventTextViewCellViewModel*)model
{
    self.model = model;
    self.textView.text = model.content;
    [self _updateFontForCellType:model.type];
    self.textView.placeholder = model.placeholder;
    self.rangeLabel.text = [NSString stringWithFormat:@"%lu", model.maxCharacter - self.textView.text.length];
}

- (void)_updateFontForCellType:(FRCreateEventCellType)type
{
    switch (type) {
        case FRCreateEventCellTypeTitle:
        {
            self.textView.font = FONT_SF_DISPLAY_REGULAR(21);
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(30);
            }];
             self.type = @"1";
        } break;
            
        case FRCreateEventCellTypeDescription:
        {
            self.textView.font = FONT_SF_DISPLAY_REGULAR(17);
             self.type = @"0";
        } break;
            
        default:
            break;
    }
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.delegate textEditing:self];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.model changeText:@""];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    if([string isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else  if ([self.type isEqualToString:@"1"])
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
       return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > self.model.maxCharacter)
    {
        self.model.content = [textView.text substringWithRange:NSMakeRange(0, self.model.maxCharacter)];
        textView.text = self.model.content;
        self.rangeLabel.text = [NSString stringWithFormat:@"%lu", self.model.maxCharacter - self.model.content.length];
    
        return;
    }
    
    self.model.content = textView.text;
    self.rangeLabel.text = [NSString stringWithFormat:@"%lu", self.model.maxCharacter - self.model.content.length];
}


#pragma mark - Lazy Load

- (UILabel*)rangeLabel
{
    if (!_rangeLabel)
    {
        _rangeLabel = [UILabel new];
        _rangeLabel.textColor = [UIColor bs_colorWithHexString:@"FF6868"];
        _rangeLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        [self.contentView addSubview:_rangeLabel];
        
        [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _rangeLabel;
}

- (UITextView*)textView
{
    if (!_textView)
    {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
        
        _textView.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_textView];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
    return _textView;
}
@end
