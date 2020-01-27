//
//  FREventPreviewAttendingCollectionCell.m
//  Friendly
//
//  Created by Jane Doe on 3/10/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewAttendingCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "MemberUser.h"
#import "FRStyleKit.h"

@interface FREventPreviewAttendingCollectionCell()

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* avatarImage;
@property (strong, nonatomic) MemberUser* userModel;


@end

@implementation FREventPreviewAttendingCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self avatarImage];
        [self nameLabel];
    }
    return self;
}

- (void) updateWithModel:(MemberUser*)model
{

    self.userModel = model;

   self.nameLabel.text = model.firstName;

   // self.nameLabel.text = model.user_id;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}

- (void)showUserProfile
{
    [self.delegate showUserProfile:self.userModel.userId];
}

#pragma mark - LazyLoad

-(UIImageView*) avatarImage
{
    if (!_avatarImage)
    {
        _avatarImage = [UIImageView new];
        _avatarImage.layer.cornerRadius = 35;
        _avatarImage.clipsToBounds = YES;
//        [_avatarImage setBackgroundColor:[UIColor magentaColor]];
        _avatarImage.image = [FRStyleKit imageOfDefaultAvatar];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatarImage addGestureRecognizer:singleTap];
        _avatarImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatarImage];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@70);
            make.left.right.equalTo(self.contentView);
        }];
    }
    return _avatarImage;
}

-(UILabel*) nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        [_nameLabel setText:@"Name"];
        [_nameLabel setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_nameLabel setFont:FONT_SF_DISPLAY_MEDIUM(15)];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.avatarImage.mas_bottom).offset(5);
        }];
    }
    return _nameLabel;
}


@end
