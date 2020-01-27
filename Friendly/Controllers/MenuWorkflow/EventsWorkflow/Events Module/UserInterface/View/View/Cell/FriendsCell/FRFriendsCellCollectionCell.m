//
//  FRFriendsCellCollectionCell.m
//  Friendly
//
//  Created by Jane Doe on 4/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendsCellCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface FRFriendsCellCollectionCell()

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* avatarImage;
@property (strong, nonatomic) FRUserModel* userModel;

@end

@implementation FRFriendsCellCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self avatarImage];
        [self nameLabel];
        
    }
    return self;
}

- (void) updateWithModel:(FRUserModel*)model
{
    self.nameLabel.text = model.first_name;
    // self.nameLabel.text = model.user_id;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.photo]];
}


#pragma mark - LazyLoad

-(UIImageView*) avatarImage
{
    if (!_avatarImage)
    {
        _avatarImage = [UIImageView new];
        _avatarImage.layer.cornerRadius = 29.5;
        _avatarImage.clipsToBounds = YES;
        [_avatarImage setBackgroundColor:[UIColor magentaColor]];
        [self.contentView addSubview:_avatarImage];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@59);
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
