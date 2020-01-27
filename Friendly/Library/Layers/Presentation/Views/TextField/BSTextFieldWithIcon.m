//
//  BSTextFieldWithIcon.m
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "BSTextFieldWithIcon.h"
#import "UITextField+RACKeyboardSupport.h"


@implementation BSTextFieldWithIcon


#pragma mark - Lazy Load

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        [self addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(@7);
            make.height.width.equalTo(@30);
        }];
    }
    return _icon;
}

- (UITextField*)textField
{
    if (!_textField)
    {
        _textField = [UITextField new];
        _textField.textColor = [UIColor whiteColor];
        [_textField.rac_keyboardReturnSignal subscribeNext:^(UITextField* x) {
            
            [x resignFirstResponder];
        }];
        [_textField setValue:[UIColor whiteColor]
                        forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(5);
            make.top.right.bottom.equalTo(self);
        }];
    }
    return _textField;
}

@end
