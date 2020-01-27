//
//  FRJoinUserCollectionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 16.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRJoinUserCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FRJoinUserCollectionCell()

@property (nonatomic, strong) UIImageView* photo;

@end

@implementation FRJoinUserCollectionCell


- (void)updateWithModel:(FRJoinUser*)model
{

    NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.photo]];
    [self.photo sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}

#pragma mark - Lazy Load

- (UIImageView*)photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
        _photo.backgroundColor = [UIColor blackColor];
        _photo.layer.cornerRadius = 12.5;
//        _photo.layer.borderWidth = 1;
        _photo.layer.borderColor = [UIColor whiteColor].CGColor;
        _photo.clipsToBounds = YES;
//        [self.contentView addSubview:_photo];
        
        UIView* whiteBorder = [UIView new];
        whiteBorder.backgroundColor = [UIColor whiteColor];
        whiteBorder.layer.cornerRadius = 27 / 2;
        
        
        [self.contentView addSubview:whiteBorder];
        
        [whiteBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.equalTo(@27);
        }];

        [whiteBorder addSubview:_photo];
        
        
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(whiteBorder);
            make.width.height.equalTo(@25);
        }];
    }
    return _photo;
}

@end


@interface FRJoinUserEmptyCollectionCell()

@property (nonatomic, strong) UILabel* countLabel;

@end

@implementation FRJoinUserEmptyCollectionCell

- (void)updateWithCount:(NSInteger)count {
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 12.5;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    self.backgroundColor = [UIColor bs_colorWithHexString:@"#E8EBF2"];
}



#pragma mark - Lazy Load

- (UILabel*)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = FONT_PROXIMA_NOVA_MEDIUM(10);
        _countLabel.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        [self.contentView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    
    return _countLabel;
}


@end

