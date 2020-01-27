//
//  FRMessagerContentView.m
//  Friendly
//
//  Created by Sergey on 16.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagerContentView.h"
#import "UIImageHelper.h"
#import "FRStyleKit.h"
#import "FRMessagesSegment.h"
#import "FRMessagerFriendsHeader.h"
#import "FRMessagerSectionHeader.h"

@interface FRMessagerContentView ()

@property (nonatomic, strong) UIButton* badgeButton;

@end

@implementation FRMessagerContentView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"FRMessagerContentView" owner:self options:nil].firstObject;
    
    return self;
}
- (void)endEditing {
    self.searchBar.text = nil;
    [self.searchBar endEditing:true];
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.leftButton setImage: [UIImageHelper image:[FRStyleKit imageOfGroup5Canvas] color:[UIColor bs_colorWithHexString:@"#939BAF"]] forState:UIControlStateNormal] ;
    [self.rightButton setImage:[UIImageHelper image:[FRStyleKit imageOfPage1Canvas4] color:[UIColor bs_colorWithHexString:@"#939BAF"]] forState:UIControlStateNormal];
    
//    self.searchBar.barTintColor = [UIColor bs_colorWithHexString:@"#6952FC"];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.barTintColor = [UIColor clearColor];
    
    
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTranslucent:YES];
    
    self.searchBar.placeholder = @"Chat search";
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.searchBar setEnablesReturnKeyAutomatically:false];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#AEB3C5"]];
    
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.backgroundColor = [UIColor bs_colorWithHexString:@"#EFF1F6"];
                textField.textColor = [UIColor bs_colorWithHexString:@"#AEB3C5"];
                
                UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
                [inpView addGestureRecognizer:gest];
                
//                textField.inputAccessoryView = inpView;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.autocorrectionType = UITextAutocorrectionTypeYes;
                UIImage* image = [FRStyleKit imageOfTabSearchCanvas];
                UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(0, 0, 15, 15);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                textField.leftView = imageView;
                textField.tintColor = [UIColor whiteColor];
                
                break;
            }
        }
    }
    
    self.tableView.separatorColor = [UIColor bs_colorWithHexString:kSeparatorColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[FRMessagerSectionHeader class] forHeaderFooterViewReuseIdentifier:@"FRMessagerSectionHeader"];
    
}


- (void)updateFriendsCount:(NSNumber*)number
{
    if (number.integerValue < 1) {
        self.badgeButton.hidden = true;
        return;
    }
    
    self.badgeButton.hidden = false;
    NSString* count = number.integerValue < 100 ? [NSString stringWithFormat:@" %ld ", (long)number.integerValue] : @" >99 ";
    
    [self.badgeButton setTitle:count forState:UIControlStateNormal];
    [self.badgeButton.titleLabel sizeToFit];
    CGFloat width = self.badgeButton.titleLabel.bounds.size.width < 19 ? 19 : self.badgeButton.titleLabel.bounds.size.width;
    
    [self.badgeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@18);
    }];
}

- (UIButton*)badgeButton
{
    if (!_badgeButton)
    {
        _badgeButton = [UIButton new];
        _badgeButton.hidden = true;
        [_badgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _badgeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _badgeButton.layer.cornerRadius = 9;
//        _badgeButton.layer.shadowRadius = 1;
//        _badgeButton.layer.shadowColor = [UIColor blackColor].CGColor;
//        _badgeButton.layer.shadowOpacity = 0.7f;
//        _badgeButton.layer.shadowOffset = CGSizeMake(0, 1);
        [_badgeButton setBackgroundColor:[UIColor bs_colorWithHexString:@"FE0000"]];
        
        [self.leftButton addSubview:_badgeButton];
        [_badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.top.equalTo(self.leftButton).offset(5);
            make.right.equalTo(self.leftButton).offset(0);
        }];
    }
    return _badgeButton;
}



@end
