//
//  FRRequestAccessVC.m
//  Friendly
//
//  Created by Sergey Borichev on 10.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRequestAccessVC.h"
#import "FRLocationManager.h"

@interface FRRequestAccessVC ()

@property (nonatomic, strong) UIImageView* backView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subdescriptionLabel;
@property (nonatomic, strong) UIButton* accessButton;
@property (nonatomic, strong) UIButton* declineButton;


@end

@implementation FRRequestAccessVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* title;
    NSString* description;
    NSString* accessTitle;
    
    if (self.mode == FRRequestAccessViewLocation)
    {
        title = FRLocalizedString(@"View nearby events", nil);
        description = FRLocalizedString(@"Share your location so we can match you with events in your area", nil);
        accessTitle = FRLocalizedString(@"Share location", nil);
    }
    else
    {
        title = FRLocalizedString(@"Stay in the loop", nil);
        description = FRLocalizedString(@"Allow notifications to stay up to date with your events and friends", nil);
        accessTitle = FRLocalizedString(@"Get notified", nil);
    }
    
    self.titleLabel.text = title;
    self.subdescriptionLabel.text = description;
    [self.accessButton setTitle:accessTitle forState:UIControlStateNormal];
    [self.declineButton addTarget:self action:@selector(declineAction) forControlEvents:UIControlEventTouchUpInside];
    [self.accessButton addTarget:self action:@selector(accessAction) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Action

- (void)declineAction
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accessAction
{
    if (self.mode == FRRequestAccessViewLocation)
    {
        [[FRLocationManager sharedInstance] verifiLocationManager];
    }
    else
    {
        
    }
    
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy Load

- (UIImageView*)backView
{
    if (!_backView)
    {
        _backView = [UIImageView new];
        _backView.userInteractionEnabled = YES;
        _backView.image = [UIImage imageNamed:@"in-app-prompt"];
        [self.view addSubview:_backView];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];;
    }
    return _backView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
      
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"292929"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(24);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset([UIScreen mainScreen].bounds.size.height / 5.3);
            make.left.equalTo(self.backView).offset(20);
            make.right.equalTo(self.backView).offset(-20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subdescriptionLabel
{
    if (!_subdescriptionLabel)
    {
        _subdescriptionLabel = [UILabel new];
        _subdescriptionLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _subdescriptionLabel.font = FONT_SF_DISPLAY_REGULAR(17);
        _subdescriptionLabel.textAlignment = NSTextAlignmentCenter;
        _subdescriptionLabel.numberOfLines = 2;
        _subdescriptionLabel.adjustsFontSizeToFitWidth = YES;
        [self.backView addSubview:_subdescriptionLabel];
        
        [_subdescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
            make.left.equalTo(self.backView).offset(47.5);
            make.right.equalTo(self.backView).offset(-47.5);
        }];
    }
    return _subdescriptionLabel;
}

- (UIButton*)accessButton
{
    if (!_accessButton)
    {
        _accessButton = [UIButton new];
        _accessButton.layer.cornerRadius = 6;
        _accessButton.titleLabel.font = FONT_PROXIMA_NOVA_BOLD(17);
        _accessButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_accessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_accessButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.backView addSubview:_accessButton];
        
        [_accessButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subdescriptionLabel.mas_bottom).offset(28);
            make.height.equalTo(@50);
            make.left.equalTo(self.backView).offset(47.5);
            make.right.equalTo(self.backView).offset(-47.5);
        }];
    }
    return _accessButton;
}

- (UIButton*)declineButton
{
    if (!_declineButton)
    {
        _declineButton = [UIButton new];
        _declineButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(15);
        [_declineButton setTitle:FRLocalizedString(@"No thanks", nil) forState:UIControlStateNormal];
        [_declineButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];
        [_declineButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.backView addSubview:_declineButton];
        
        [_declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accessButton.mas_bottom).offset(5);
            make.height.equalTo(@50);
            make.left.equalTo(self.backView).offset(47.5);
            make.right.equalTo(self.backView).offset(-47.5);
        }];
    }
    return _declineButton;
}

@end
