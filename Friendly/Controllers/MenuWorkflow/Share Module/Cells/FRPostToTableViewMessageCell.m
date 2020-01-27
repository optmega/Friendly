//
//  FRPostToTableViewMessageCell.m
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPostToTableViewMessageCell.h"

@interface FRPostToTableViewMessageCell() <UITextViewDelegate>

@property (strong, nonatomic) UIView* separator;

@end

@implementation FRPostToTableViewMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self messageView];
        [self separator];
    }
    return self;
}

-(void)updateMessageViewWithText:(NSString*)message
{
    self.messageView.text = message;
}


#pragma mark - TextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.delegate scrollView];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.delegate changeMessage:textView.text];
    [self.delegate scrollViewBack];
    return YES;
}

-(void)endEditing
{
    [self.messageView endEditing:YES];
}


#pragma mark - LazyLoad

-(UITextView*) messageView
{
    if (!_messageView)
    {
        _messageView = [UITextView new];
        _messageView.delegate = self;
        _messageView.autocorrectionType = UITextAutocorrectionTypeYes;
        _messageView.textContainerInset = UIEdgeInsetsMake(22, 15, 0, 15);
        _messageView.textContainer.lineFragmentPadding = 0;
//        UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
//        [inpView addGestureRecognizer:gest];
//        _messageView.inputAccessoryView = inpView;
        _messageView.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _messageView.font = FONT_SF_DISPLAY_REGULAR(18);
        [self.contentView addSubview:_messageView];
        [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
    }
    return _messageView;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.messageView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end
