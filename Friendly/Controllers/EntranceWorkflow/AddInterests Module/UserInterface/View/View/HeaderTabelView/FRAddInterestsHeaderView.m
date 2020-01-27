//
//  FRAddInterestsHeaderView.m
//  Friendly
//
//  Created by Sergey Borichev on 03.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsHeaderView.h"
#import "FRHeaderQuestionairView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъьэыюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯ"

@interface FRAddInterestsHeaderView () <UISearchBarDelegate>

@property (nonatomic, strong) UIImageView* backgroundHeaderImage;
@property (nonatomic, strong) UIView* navBar;
@property (nonatomic, strong) FRHeaderQuestionairView* headerView;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIButton* continueButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* headerCornerImage;

@end

static CGFloat const kHeaderTopOffset = 15;


@implementation FRAddInterestsHeaderView



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self backgroundHeaderImage];
        [self headerView];
        [self searchBar];
        [self titleLabel];
        [self headerCornerImage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self.searchBar selector:@selector(resignFirstResponder) name:@"hideKeyboardFromSearchBar" object:nil];
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
        
        for (UIView *subview in self.searchBar.subviews)
        {
            for (UIView *subSubview in subview.subviews)
            {
                if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
                {
                    UITextField *textField = (UITextField *)subSubview;
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.backgroundColor = [UIColor bs_colorWithHexString:@"#F4F5F8"];
                    textField.layer.cornerRadius = 7;
                    
                    CGFloat width = [UIScreen mainScreen].bounds.size.width;
                    
                    textField.autocorrectionType = UITextAutocorrectionTypeYes;
                    
                    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
                    toolbar.barTintColor = [UIColor whiteColor];
                    
                    
                    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
                    [self.addButton setTitle:@"Add tag" forState:UIControlStateNormal];
                    self.addButton.layer.cornerRadius = 5;
                    self.addButton.layer.borderWidth = 1;
                    self.addButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
                    [self.addButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
                    self.addButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(13);
                    [self.addButton addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
                    self.addButton.enabled = NO;
                    UIBarButtonItem* done = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
                    
                    
                    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
                    label.text = @"Stap 1 of 3";
                    label.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
                    label.font = FONT_MAIN_FONT(13);
                    UIBarButtonItem* labelItem = [[UIBarButtonItem alloc]initWithCustomView:label];
                    
                    
                    self.continueButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
                    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
                    self.continueButton.backgroundColor = [UIColor bs_colorWithHexString:kFriendlyBlueColor];
                    self.continueButton.layer.cornerRadius = 5;
                    
                    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.continueButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(13);
                    [self.continueButton addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIBarButtonItem* continueItem = [[UIBarButtonItem alloc]initWithCustomView:self.continueButton];
                    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    UIBarButtonItem *spaceFix10 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                    spaceFix10.width = 10;
                    UIBarButtonItem *spaceFix5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                    spaceFix10.width = 5;
                    
                    
                    toolbar.items = @[spaceFix10, labelItem, space, done, spaceFix5, continueItem, spaceFix10];
                    
                    UIView* inpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
                    [inpView addSubview:toolbar];
                    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.bottom.right.equalTo(inpView);
                        make.height.equalTo(@50);
                    }];
                    textField.inputAccessoryView = inpView;
                    
                    UIImage* image = [FRStyleKit  imageOfTabSearchCanvas];
                    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
                    imageView.frame = CGRectMake(0, 0, 15, 15);
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    textField.leftView = imageView;
                    
                    UIButton *btnClear = [textField valueForKey:@"_clearButton"];
                    UIImage *imageNormal = [btnClear imageForState:UIControlStateNormal];
                    UIGraphicsBeginImageContextWithOptions(imageNormal.size, NO, 0.0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    
                    CGRect rect = (CGRect){ CGPointZero, imageNormal.size };
                    CGContextSetBlendMode(context, kCGBlendModeNormal);
                    [imageNormal drawInRect:rect];
                    
                    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
                    [[UIColor bs_colorWithHexString:@"#D5D9E0"] setFill];
                    CGContextFillRect(context, rect);
                    
                    UIImage *imageTinted  = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [btnClear setImage:imageTinted forState:UIControlStateNormal];
                    
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    [button setImage:[UIImageHelper image:[UIImage imageNamed:@"cancelSearchButton"] color:[UIColor bs_colorWithHexString:@"#D5D9E0"]] forState:UIControlStateNormal];
//                    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    [button setFrame:CGRectMake(0, 0, 15, 15)]; // Required for iOS7
//                    textField.rightView = button;
//                    textField.rightViewMode = UITextFieldViewModeWhileEditing;
                    
                    break;
                }
            }
        }
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)note
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchBarClicked" object:note.userInfo];

    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)continueAction:(UIButton*)sender
{
    [self.delegate selectedContinue];
}

- (void)endEditing
{
    [self disableAddButton];
    [self.searchBar setText:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyboardFromSearchBar" object:nil];
}

- (void)addTag
{
    [self searchBarSearchButtonClicked:self.searchBar];
    [self disableAddButton];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.delegate addTag:searchBar.text];
    searchBar.text = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyboardFromSearchBar" object:nil];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        return NO;
    }
//    else
//    {
//      NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//        
//        NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        
//        return [text isEqualToString:filtered];
//    }
    return YES;

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length)
    {
        self.addButton.enabled = YES;
        self.addButton.backgroundColor = [UIColor bs_colorWithHexString:@"#6349CA"];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
        return;
    }
    [self disableAddButton];
}



- (void)disableAddButton
{
    self.addButton.enabled = NO;
    self.addButton.backgroundColor = [UIColor whiteColor];
    self.addButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
    [self.addButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
}

- (UIImageView*)backgroundHeaderImage
{
    return nil;
    if (!_backgroundHeaderImage)
    {
        _backgroundHeaderImage = [UIImageView new];
        _backgroundHeaderImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundHeaderImage.image = [UIImage imageNamed:@"questionair-1"];
        _backgroundHeaderImage.clipsToBounds = YES;
        [self addSubview:_backgroundHeaderImage];
        
        [_backgroundHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
//            make.bottom.equalTo(self.headerView);
            make.height.equalTo(@130);
        }];
    }
    return _backgroundHeaderImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _titleLabel.text = FRLocalizedString(@"ADD 3 OR MORE INTERESTS", nil);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.searchBar.mas_bottom).offset(20);
        }];
    }
    return _titleLabel;
}


- (UIView*)navBar
{
    if (!_navBar)
    {
        _navBar = [UIView new];
        [self addSubview:_navBar];
        
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}

- (FRHeaderQuestionairView*)headerView
{
    if (!_headerView)
    {
        _headerView = [[FRHeaderQuestionairView alloc]initWithTitle:FRLocalizedString(@"", nil)
                                                           subtitle:FRLocalizedString(@"Add interests and get\n discovered by more users", nil)];
        _headerView.hidden = true;
        [self addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom).offset(-kHeaderTopOffset);
            make.left.right.equalTo(self);
            make.height.equalTo(@0);//(@(111 + kHeaderTopOffset));
        }];
    }
    return _headerView;
}

- (UISearchBar*)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [UISearchBar new];
        
        _searchBar.delegate  = self;
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.placeholder = FRLocalizedString(@"Add your own tags", nil);
        _searchBar.layer.cornerRadius = 7;
        [self addSubview:_searchBar];
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(-28);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@33);
        }];
    }
    return _searchBar;
}

-(UIImageView*)headerCornerImage
{
    return nil;
    if (!_headerCornerImage)
    {
        _headerCornerImage = [UIImageView new];
        [_headerCornerImage setImage:[FRStyleKit imageOfGroup4Canvas2]];
        [self addSubview:_headerCornerImage];
        [self.backgroundHeaderImage bringSubviewToFront:_headerCornerImage];
        [_headerCornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@10);
        }];
    }
    return _headerCornerImage;
}

@end
