//
//  FRUserProfileHeaderCell.m
//  Friendly
//
//  Created by Sergey Borichev on 30.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileHeaderCell.h"
#import "FRStyleKit.h"
#import "FRUserProfileFriendActionView.h"

@interface FRUserProfileHeaderCell ()<FRUserProfileFriendActionViewDelegate>

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UILabel* professionLabel;
@property (nonatomic, strong) UILabel* awayLabel;
@property (nonatomic, strong) FRUserProfileFriendActionView* actionView;

@property (nonatomic, strong) FRUserProfileHeaderCellViewModel* model;


@end

@implementation FRUserProfileHeaderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.saveEditButton.hidden = YES;
        self.backButton.hidden = YES;
        self.settingButton.backgroundColor = [UIColor whiteColor];
        [self.settingButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.top.equalTo(self.workFieldView).offset(10);
        }];
        
        [self.settingButton setImage:[FRStyleKit imageOfFeildMoreOptionsCanvas] forState:UIControlStateNormal];
        
        
        @weakify(self);
        [[self.settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model settingSelected];
            
        }];
        
//        [[self.settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//            [self.model settingSelected];
//        }];
//        
        [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model backSelected];
        }];
        
        [[self.saveEditButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model saveSelected];
        }];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.userPhoto.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)updateWithModel:(FRUserProfileHeaderCellViewModel*)model
{
    self.model = model;
    [self.model updateUserPhoto:self.userPhoto];
    self.usernameLabel.text = self.model.userName;
    self.professionLabel.text = self.model.profession;
    self.awayLabel.text = self.model.away;
    
    [self.actionView setMode:model.friendMode];
}


#pragma mark - FRUserProfileFriendActionViewDelegate

- (void)pendingSelected
{
    [self.model pendingSelected];
}

- (void)addFriendSelected
{
    [self.model addFriendSelected];
}

- (void)inviteToEventSelected
{
    [self.model inviteToEventSelected];
}

- (void)friendsSelected
{
    [self.model friendsSelected];
}


#pragma mark - Lazy Load

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        _backButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.6];
        _backButton.layer.cornerRadius = 17.5;
        [_backButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
        [self.userWallPhoto addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userWallPhoto).offset(30);
            make.left.equalTo(self.contentView).offset(20);
            make.height.width.equalTo(@35);
        }];
    }
    return _backButton  ;
}

- (UILabel*)professionLabel
{
    if (!_professionLabel)
    {
        _professionLabel = [UILabel new];
        _professionLabel.textColor = [UIColor bs_colorWithHexString:@"606671"];
        _professionLabel.font = FONT_SF_DISPLAY_REGULAR(17);
        _professionLabel.adjustsFontSizeToFitWidth = YES;
        _professionLabel.textAlignment = NSTextAlignmentCenter;
        _professionLabel.numberOfLines = 0;
        [_professionLabel sizeToFit];
        [self.workFieldView addSubview:_professionLabel];
        
        [_professionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workFieldView).offset(20);
            make.right.equalTo(self.workFieldView).offset(-20);
            make.top.equalTo(self.usernameLabel.mas_bottom).offset(2);
        }];
    }
    return _professionLabel;
}

- (UILabel*)awayLabel
{
    if (!_awayLabel)
    {
        _awayLabel = [UILabel new];
        _awayLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _awayLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        _awayLabel.textAlignment = NSTextAlignmentCenter;
        [self.workFieldView addSubview:_awayLabel];
        
        [_awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.professionLabel.mas_bottom).offset(4);
            make.centerX.equalTo(self.professionLabel);
        }];
    }
    return _awayLabel;
}

- (FRUserProfileFriendActionView*)actionView
{
    if (!_actionView)
    {
        _actionView = [FRUserProfileFriendActionView new];
        _actionView.delegate = self;
        _actionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_actionView];
        
        [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.awayLabel.mas_bottom).offset(10);
            make.height.equalTo(@35);
            make.left.right.equalTo(self.workFieldView);
        }];
    }
    return _actionView;
}
@end
