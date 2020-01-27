//
//  FRProfilePolishHeaderCell.m
//  Friendly
//
//  Created by Sergey Borichev on 12.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishHeaderCell.h"
#import "FRHeaderQuestionairView.h"
#import "FRStyleKit.h"

@interface FRProfilePolishHeaderCell ()

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) FRHeaderQuestionairView* headerView;
@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, strong) UIButton* changePhotoButton;
@property (nonatomic, strong) UILabel* changePhotoLable;
@property (nonatomic, strong) UIImageView* backgroundHeaderImage;
@property (nonatomic, strong) UIView* navBar;
@property (nonatomic, strong) FRProfilePolishHeaderCellViewModel* model;
@property (nonatomic, strong) UIView* circleView;
@property (nonatomic, strong) UIImageView* headerCornerImage;


@end

static CGFloat const kHeaderTopOffset = 15;

@implementation FRProfilePolishHeaderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self headerCornerImage];
        [self backgroundHeaderImage];
        [self headerView];
        
        @weakify(self);
        [[self.changePhotoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model selectedChangePhoto];
        }];
        [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model selectedBack];
        }];
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
        
        [self circleView];
        [self photo];
        [self.contentView bringSubviewToFront:_photo];
        self.backButton.hidden = YES;
    }
    return self;
}


- (void)updateWithModel:(FRProfilePolishHeaderCellViewModel*)model
{
    self.model = model;
    if (model.photo)
    {
        self.photo.image = model.photo;
        return;
    }
    [model updateUserPhoto:self.photo];
}

- (UIImage *)image:(UIImage*)image
{
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [[[UIColor whiteColor] colorWithAlphaComponent:0.8] set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


#pragma mark - Lazy Load

- (UIView*)circleView
{
    if (!_circleView)
    {
        _circleView = [UIView new];
        _circleView.backgroundColor = [UIColor whiteColor];
        _circleView.layer.cornerRadius = 57;
        
        [self.contentView addSubview:_circleView];
        
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.photo);
            make.height.width.equalTo(@114);
        }];
    }
    return _circleView;
}

- (UIImageView*)backgroundHeaderImage
{
    if (!_backgroundHeaderImage)
    {
        _backgroundHeaderImage = [UIImageView new];
        _backgroundHeaderImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundHeaderImage.image = [UIImage imageNamed:@"questionair-3"];
        [self.contentView addSubview:_backgroundHeaderImage];
        
        [_backgroundHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.headerView);
            make.height.equalTo(@130);
        }];
    }
    return _backgroundHeaderImage;
}


- (UIView*)navBar
{
    if (!_navBar)
    {
        _navBar = [UIView new];
        [self.contentView addSubview:_navBar];
        
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
        [_backButton setImage:[self image:[FRStyleKit imageOfNavBackCanvas]] forState:UIControlStateHighlighted];
        _backButton.tintColor = [UIColor whiteColor];
        [self.navBar addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.bottom.equalTo(self.navBar);
            make.left.equalTo(self.navBar).offset(5);
        }];
    }
    return _backButton;
}

- (FRHeaderQuestionairView*)headerView
{
    if (!_headerView)
    {
        _headerView = [[FRHeaderQuestionairView alloc]initWithTitle:FRLocalizedString(@"", nil) subtitle:FRLocalizedString(@"Time to fluff up your profile with\nall that good stuff!", nil)];
        [self.contentView addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.navBar.mas_bottom).offset(- kHeaderTopOffset);
            make.left.right.equalTo(self);
            make.height.equalTo(@(111 + kHeaderTopOffset));
        }];
    }
    return _headerView;
}

- (UIImageView*)photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
        
        _photo.backgroundColor = [UIColor whiteColor];
        [_photo setImage:[FRStyleKit imageOfDefaultAvatar]];
        //        _photo.image = [UIImage imageNamed:@"Login-flow_ Main user"];
//        _photo.layer.borderWidth = 5;
        _photo.layer.cornerRadius = 55;
        _photo.layer.borderColor = [UIColor whiteColor].CGColor;
        _photo.layer.masksToBounds = YES;
        [self.contentView addSubview:_photo];
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@110);
            make.centerY.equalTo(self.headerView.mas_bottom).offset(-5);
            make.centerX.equalTo(self);
        }];
        
    }
    return _photo;
}

- (UILabel*)changePhotoLable
{
    if (!_changePhotoLable)
    {
        _changePhotoLable = [UILabel new];
        _changePhotoLable.text = FRLocalizedString(@"Profile picture", nil);
        _changePhotoLable.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _changePhotoLable.font = FONT_PROXIMA_NOVA_SEMIBOLD(17);
        [self.contentView addSubview:_changePhotoLable];
        
        [_changePhotoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.photo.mas_bottom).offset(10);
        }];
    }
    return _changePhotoLable;
}

- (UIButton*)changePhotoButton
{
    if (!_changePhotoButton)
    {
        _changePhotoButton = [UIButton new];
        [_changePhotoButton setImage:[FRStyleKit imageOfUploadCanvas] forState:UIControlStateNormal];
        _changePhotoButton.tintColor = [UIColor whiteColor];
        [_changePhotoButton setTitle:FRLocalizedString(@" Change", nil) forState:UIControlStateNormal];
        _changePhotoButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        [_changePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changePhotoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        _changePhotoButton.layer.cornerRadius = 13.5;
        _changePhotoButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.contentView addSubview:_changePhotoButton];
        
        [_changePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.changePhotoLable.mas_bottom).offset(10);
            make.width.equalTo(@77.5);
            make.height.equalTo(@27);
        }];
    }
    return _changePhotoButton;
}

-(UIImageView*)headerCornerImage
{
    if (!_headerCornerImage)
    {
        _headerCornerImage = [UIImageView new];
        [_headerCornerImage setImage:[FRStyleKit imageOfGroup4Canvas2]];
        [self.backgroundHeaderImage addSubview:_headerCornerImage];
        [self.backgroundHeaderImage bringSubviewToFront:_headerCornerImage];
        [_headerCornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.backgroundHeaderImage);
            make.height.equalTo(@10);
        }];
    }
    return _headerCornerImage;
}

@end
