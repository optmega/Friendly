//
//  FRProfileFriendCollectionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileFriendCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FREventModel.h"
#import "MutualUser.h"
#import "FRStyleKit.h"

@interface FRProfileFriendCollectionCell ()



@end

@implementation FRProfileFriendCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)showUserProfile
{
    if (self.model)
    {
        
        [self.delegate showUserProfile:self.model.userId];
    }
    if (self.userEntity)
    {
        [self.delegate showUserProfileWithEntity:self.userEntity];
    }
}

- (void)updateWithUserEntityModel:(UserEntity*)model
{
    self.contentView.clipsToBounds = true;
    self.userEntity = model;
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:model.userPhoto]];
    
    [self.image sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    self.nameLabel.text = model.firstName;
    [self faceBookLogoImage];

}

- (void) addMode {
    self.nameLabel.text = @"Add";
    self.image.image = [FRStyleKit imageOfActionBarAddUser];
}

- (void)updateWithModel:(MutualUser*)model
{
    self.model = model;

    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:model.photo]];

    [self.image sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    self.nameLabel.text = model.firstName;
    [self faceBookLogoImage];
}


#pragma mark - Lazy Load

- (UIImageView*)image
{
    if (!_image)
    {
        _image = [UIImageView new];
        _image.layer.cornerRadius = 35;
        _image.clipsToBounds = YES;
        _image.userInteractionEnabled = YES;
        [self.contentView addSubview:_image];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_image addGestureRecognizer:singleTap];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.width.equalTo(@70);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _image;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

- (UIImageView*)faceBookLogoImage
{
    if (!_faceBookLogoImage)
    {
        _faceBookLogoImage = [UIImageView new];
        _faceBookLogoImage.hidden = YES;
        _faceBookLogoImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_faceBookLogoImage];
        [_faceBookLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image).offset(4);
            make.right.equalTo(self.image);
            make.height.width.equalTo(@17);
        }];
    }
    return _faceBookLogoImage;
}

@end
