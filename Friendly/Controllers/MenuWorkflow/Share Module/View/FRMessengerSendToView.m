//
//  FRMessengerSendToView.m
//  Friendly
//
//  Created by User on 28.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessengerSendToView.h"

@interface FRMessengerSendToView()

@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UITextField* searchField;
@property (strong, nonatomic) UILabel* sendToLabel;

@end

@implementation FRMessengerSendToView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self separator];
        [self searchField];
        [self sendToLabel];
    }
    return self;
}


#pragma mark - LazyLoad

-(UILabel *)sendToLabel
{
    if (!_sendToLabel) {
        _sendToLabel = [UILabel new];
        [_sendToLabel setText:@"Send to:"];
        _sendToLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(15);
        [_sendToLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self addSubview:_sendToLabel];
        [_sendToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return _sendToLabel;
}

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UITextField*)searchField
{
    if (!_searchField)
    {
        _searchField = [UITextField new];
        [_searchField setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        _searchField.font = FONT_PROXIMA_NOVA_SEMIBOLD(15);
        [self addSubview:_searchField];
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(self);
            make.left.equalTo(self.sendToLabel.mas_right).offset(5);
        }];
    }
    return _searchField;
}

@end
