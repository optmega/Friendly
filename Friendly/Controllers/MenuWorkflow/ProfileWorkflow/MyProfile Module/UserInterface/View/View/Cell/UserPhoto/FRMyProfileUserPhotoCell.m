//
//  FRMyProfileUserPhotoCell.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileUserPhotoCell.h"
#import "FRStyleKit.h"
#import "FRMyProfileStatusInputView.h"
#import "FRUserManager.h"

@interface FRMyProfileUserPhotoCell() <FRMyProfileStatusInputViewDelegate>

@property (nonatomic, strong) UILabel* professionLabel;
@property (nonatomic, strong) UIView* statusView;
@property (nonatomic, strong) FRMyProfileUserPhotoCellViewModel* model;
@property (nonatomic, strong) UIButton* statusButton;
@property (nonatomic, strong) UIImageView* arrowImage;
@property (nonatomic, strong) UITextField* textField;

@end

@implementation FRMyProfileUserPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.saveEditButton setTitle:FRLocalizedString(@"Edit info", nil) forState:UIControlStateNormal];
        
        @weakify(self);
        [[self.saveEditButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model saveSelected];
        }];
         
        
        [[self.settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model settingSelected];
        }];
//        
//        [[self.statusButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
////            [self.textField becomeFirstResponder];
//            
//            [self.model statusSelected];
//        }];
//         [self arrowImage];
        
        [self.settingButton setImage:[FRStyleKit imageOfFill1Canvas2] forState:UIControlStateNormal];
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.userWallPhoto.hidden = true;
    return self;
}

- (void)updateWithModel:(FRMyProfileUserPhotoCellViewModel*)model
{
//    self.userPhoto.image = [FRUserManager sharedInstance].currentUserPhoto;
    self.model = model;
    [self.model updateUserPhoto:self.userPhoto];
//        [self.model updateUserPhoto:model.userPhotoImage];
    [self.model updateWallImage:self.userWallPhoto];
    self.usernameLabel.text = self.model.userName;
    self.professionLabel.text = self.model.profession;
//    [self.statusButton setTitle:model.statusString.uppercaseString forState:UIControlStateNormal];
}


#pragma mark - Lazy Load

- (UILabel*)professionLabel
{
    if (!_professionLabel)
    {
        _professionLabel = [UILabel new];
        _professionLabel.textAlignment = NSTextAlignmentCenter;
        _professionLabel.textColor = [UIColor bs_colorWithHexString:@"606671"];
        _professionLabel.font = FONT_PROXIMA_NOVA_REGULAR(17);
        _professionLabel.adjustsFontSizeToFitWidth = YES;
        _professionLabel.textAlignment = NSTextAlignmentCenter;
        _professionLabel.numberOfLines = 0;
        [_professionLabel sizeToFit];
        [self.workFieldView addSubview:_professionLabel];
        
        [_professionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usernameLabel.mas_bottom).offset(3);
            make.left.right.equalTo(self.usernameLabel);
        }];
    }
    return _professionLabel;
}

//- (UIButton*)statusButton
//{
//    if (!_statusButton)
//    {
//        _statusButton = [UIButton new];
//        _statusButton.userInteractionEnabled = YES;
//        _statusButton.backgroundColor = [UIColor bs_colorWithHexString:@"765BF8"];
//        _statusButton.layer.cornerRadius = 4;
//        _statusButton.titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(11);
//        _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
//        [_statusButton setTitle:@"AVAILABLE FOR A MEET" forState:UIControlStateNormal];
//        _statusButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [self.contentView addSubview:_statusButton];
//        
//        [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.professionLabel.mas_bottom).offset(5);
//            make.centerX.equalTo(self.workFieldView);
//            make.height.equalTo(@19);
//            make.width.equalTo(@138);
//        }];
//    }
//    return _statusButton;
//}
//
//- (UIImageView*)arrowImage
//{
//    if (!_arrowImage)
//    {
//        _arrowImage = [UIImageView new];
//        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
//        _arrowImage.transform = CGAffineTransformRotate(_arrowImage.transform, M_PI_2);
//        [self.workFieldView addSubview:_arrowImage];
//        
//        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@13);
//            make.centerY.equalTo(self.userPhoto);
//            make.left.equalTo(self.userPhoto.mas_right).offset(4);
//        }];
//    }
//    return _arrowImage;
//}

- (UITextField*)textField
{
    if (!_textField)
    {
        _textField = [UITextField new];
        _textField.alpha = 0;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        FRMyProfileStatusInputView*inputView = [[FRMyProfileStatusInputView alloc] initWithFrame:CGRectMake(0, 0, width, 295)];
        _textField.inputView = inputView;
        inputView.delegate = self;
        
        UIView* accessoryView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        accessoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
        [accessoryView addGestureRecognizer:tapGest];
        _textField.inputAccessoryView = accessoryView;
        [self addSubview:_textField];
        
    }
    return _textField;
}

//- (void)selectedStatus:(NSString*)status
//{
//    [self.statusButton setTitle:status.uppercaseString forState:UIControlStateNormal];
//    [self endEditing];
//}

- (void)close
{
    
}

- (void)endEditing
{

    [self.textField resignFirstResponder];
}

@end
