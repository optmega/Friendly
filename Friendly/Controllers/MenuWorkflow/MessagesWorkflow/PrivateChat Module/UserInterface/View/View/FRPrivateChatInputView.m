//
//  FRPrivateChatInputView.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatInputView.h"
#import "FRStyleKit.h"
#import "UITextView+Placeholder.h"

/*
 
 @property (nonatomic, strong) UIImageView* userImage;
 @property (nonatomic, strong) UITextView* textView;
 @property (nonatomic, strong) UIButton* senderButton;
 
 */

@interface FRPrivateChatInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView* separatorView;

@end

@implementation FRPrivateChatInputView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self textView];
        [self separatorView];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    UILabel
}

#pragma mark - LazyLoad

- (UIImageView*)userImage
{
    if (!_userImage)
    {
        _userImage = [UIImageView new];
        _userImage.layer.cornerRadius = 15;
        _userImage.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_userImage];
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-10);
            make.height.width.equalTo(@30);
        }];
    }
    return _userImage;
}

- (UIButton*)senderButton
{
    if (!_senderButton)
    {
        _senderButton = [UIButton new];
        [_senderButton setImage:[FRStyleKit imageOfSendMessageOffCanvas] forState:UIControlStateNormal];
        
        [self addSubview:_senderButton];
        [_senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@30);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _senderButton;
}

- (UITextView*)textView
{
    if (!_textView)
    {
        _textView = [UITextView new];
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.backgroundColor = [UIColor redColor];
        _textView.delegate = self;
        _textView.placeholder = @"Type a message...";
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userImage.mas_right).offset(10);
            make.right.equalTo(self.senderButton.mas_left).offset(-10);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
        }];
    }
    return _textView;
}

- (UIView*)separatorView
{
    if (!_separatorView)
    {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separatorView;
}


@end
