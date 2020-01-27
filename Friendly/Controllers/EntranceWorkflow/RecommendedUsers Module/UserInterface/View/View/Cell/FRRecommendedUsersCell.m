//
//  FRRecommendedUsersCell.m
//  Friendly
//
//  Created by Sergey Borichev on 04.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersCell.h"

@interface FRRecommendedUsersCell ()

@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, strong) UILabel* usernameLabel;
@property (nonatomic, strong) UILabel* interestsLabel;
@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) FRRecommendedUsersCellViewModel* model;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRRecommendedUsersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self separator];
        @weakify(self);
        [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* x) {
            @strongify(self);
            if (!x.selected)
            {
                [self.model addUser];
                x.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
                [x setTitle:@"Requested" forState:UIControlStateNormal];
                x.selected = !x.selected;
                self.model.isRequstedMode = YES;
            }
        }];
    }
    return self;
}
- (void)updateWithModel:(FRRecommendedUsersCellViewModel*)model
{
    self.model = model;
    self.photo.backgroundColor = [UIColor bs_colorWithHexString:@"#D2D5DA"];
    self.usernameLabel.text = model.username;
    self.interestsLabel.text = model.usersInterests;
    [self.model updateUserPhoto:self.photo];
    
    if (model.isRequstedMode)
    {
        self.addButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        [self.addButton setTitle:@"Requested" forState:UIControlStateNormal];
        self.addButton.selected = YES;
    }
    else
    {
        self.addButton.backgroundColor = [UIColor whiteColor];
        [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
        self.addButton.selected = NO;
    }
    
}

-(void)showUserProfile
{
    [self.model showUserProfile];
}

#pragma mark - Lazy Load

- (UIImageView*)photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
        _photo.layer.cornerRadius = 27.5;
        _photo.clipsToBounds = YES;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_photo addGestureRecognizer:singleTap];
        _photo.userInteractionEnabled = YES;
        [self.contentView addSubview:_photo];
        
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@55);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _photo;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel)
    {
        _usernameLabel = [UILabel new];
        _usernameLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _usernameLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(18);
        [self addSubview:_usernameLabel];
        
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.photo.mas_right).offset(10);
            make.right.equalTo(self.addButton.mas_left).offset(-10);
        }];
    }
    return _usernameLabel;
}

- (UILabel*)interestsLabel
{
    if (!_interestsLabel)
    {
        _interestsLabel = [UILabel new];
        _interestsLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _interestsLabel.font = FONT_MAIN_FONT(14);
        [self.contentView addSubview:_interestsLabel];
        
        [_interestsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photo.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_centerY).offset(3);
            make.right.equalTo(self.usernameLabel);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return _interestsLabel;
}

- (UIButton*)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton new];
        _addButton.titleLabel.font = FONT_MAIN_FONT(14);
        _addButton.layer.borderColor = [UIColor bs_colorWithHexString:@"#E8EBF1"].CGColor;
        _addButton.layer.borderWidth = 1;
        _addButton.layer.cornerRadius = 5;
        
        [_addButton setTitle:@"Add" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];
        [self addSubview:_addButton];
        
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@30);
            make.width.equalTo(@81);
        }];
    }
    return _addButton;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:@"E4E6EA"]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end
