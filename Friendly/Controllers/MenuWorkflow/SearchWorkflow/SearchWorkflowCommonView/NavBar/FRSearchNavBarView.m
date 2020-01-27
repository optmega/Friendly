//
//  FRSearchNavBarView.m
//  Friendly
//
//  Created by Sergey Borichev on 19.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchNavBarView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"
@interface FRSearchNavBarView () 

@end

@implementation FRSearchNavBarView

#pragma mark - Lazy Load


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
        
        for (UIView *subview in self.searchBar.subviews)
        {
            for (UIView *subSubview in subview.subviews)
            {
                if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
                {
                    UITextField *textField = (UITextField *)subSubview;
                    textField.backgroundColor = [UIColor bs_colorWithHexString:@"EFF1F6"];
                    textField.textColor = [UIColor bs_colorWithHexString:@"ADB3C4"];
//                    textField.returnKeyType = UIReturnKeyDone;
                    
                    UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                    UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
                    [inpView addGestureRecognizer:gest];
                    textField.font = FONT_SF_DISPLAY_MEDIUM(15);
                                    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                        UIColor *color = [UIColor bs_colorWithHexString:@"ADB3C4"];
                        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event search            " attributes:@{NSForegroundColorAttributeName: color}];
                    } else {
                        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
                    }

                    
                    textField.inputAccessoryView = inpView;
                    textField.autocorrectionType = UITextAutocorrectionTypeYes;
                    UIImage* image = [UIImageHelper image:[FRStyleKit imageOfTabSearchCanvas2] color:[UIColor bs_colorWithHexString:@"ADB3C4"]];
                    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
                    imageView.frame = CGRectMake(0, 0, 20, 20);
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    textField.leftView = imageView;
                    textField.tintColor = [UIColor whiteColor];
                    
                    break;
                }
            }
        }
    }
    return self;
}

- (void)endEditing
{
    [self endEditing:YES];
}



- (UISearchBar*)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [UISearchBar new];
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.placeholder = FRLocalizedString(@"Search", nil);
        [self addSubview:_searchBar];
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(-5);
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self);
        }];
    }
    return _searchBar;
}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@30);
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self.searchBar);
        }];
    }
    return _backButton;
}

@end
