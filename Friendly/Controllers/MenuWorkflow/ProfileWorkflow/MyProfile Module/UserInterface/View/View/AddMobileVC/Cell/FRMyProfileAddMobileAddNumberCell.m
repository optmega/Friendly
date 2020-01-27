//
//  FRMyProfileAddMobileAddNumberCell.m
//  Friendly
//
//  Created by User on 23.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileAddMobileAddNumberCell.h"
#import "UITextfieldHelper.h"

@interface FRMyProfileAddMobileAddNumberCell() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* addNumberButton;

@end

@implementation FRMyProfileAddMobileAddNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self textField];
        [self titleLabel];
        [self addNumberButton];
    }
    return self;
}

- (void)addNumber
{
    [self.delegate addNumber:[self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    
    if (range.length == 1){
        textField.text = [UITextfieldHelper formatPhoneNumber:totalString deleteLastChar:YES];
        
    } else {
        textField.text = [UITextfieldHelper formatPhoneNumber:totalString deleteLastChar:NO];
    }
    
    return false;
}



#pragma mark - LazyLoad

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"MOBILE NUMBER";
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UITextField*)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.font = FONT_PROXIMA_NOVA_MEDIUM(16);
        _textField.delegate = self;
        _textField.placeholder = @"Enter your number...";
        _textField.tintColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@20);
        }];
    }
    return _textField;
}

- (UIButton*)addNumberButton
{
    if (!_addNumberButton) {
        _addNumberButton = [UIButton new];
        [_addNumberButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        _addNumberButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(13);
        _addNumberButton.layer.cornerRadius = 5;
        [_addNumberButton addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
        [_addNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addNumberButton setTitle:@"Add number" forState:UIControlStateNormal];
        [self.contentView addSubview:_addNumberButton];
        [_addNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textField.mas_bottom).offset(20);
            make.left.equalTo(self.textField);
            make.width.equalTo(@85);
            make.height.equalTo(@30);
        }];
    }
    return _addNumberButton;
}

@end
