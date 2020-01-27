//
//  FRCreateEventInviteFriendsSearchView.m
//  Friendly
//
//  Created by Jane Doe on 3/22/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteFriendsSearchView.h"
#import "FRStylekit.h"

@interface FRCreateEventInviteFriendsSearchView()


@end

@implementation FRCreateEventInviteFriendsSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self searchField];
        [self closeButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


//- (BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//    
//}


#pragma mark - LazyLoad

- (UITextField*) searchField
{
    if (!_searchField)
    {
        _searchField = [UITextField new];
        _searchField.placeholder = @"Search...";
        _searchField.autocorrectionType = UITextAutocorrectionTypeYes;
        _searchField.returnKeyType = UIReturnKeySearch;
        [self addSubview:_searchField];
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.right.equalTo(self.closeButton.mas_left);
        }];
    }
    return _searchField;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        _closeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        UIImage *image = [FRStyleKit imageOfAttendeeRemoveCanvas2];
        [_closeButton setImage:image forState:UIControlStateNormal];
        _closeButton.clipsToBounds = YES;
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.right.equalTo(self).offset(-2);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return _closeButton;
}


@end
