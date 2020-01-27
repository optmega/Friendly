//
//  FRPhotosCollectionVeiwCell.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPhotosCollectionVeiwCell.h"
#import "UIImageView+WebCache.h"
#import "InstagramImage.h"
#import "FRStyleKit.h"

@interface FRPhotosCollectionVeiwCell()

@property (nonatomic, strong) UILabel* viewAllLabel;

@end

@implementation FRPhotosCollectionVeiwCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewAllLabel.hidden = YES;
    }
    return self;
}

//Serg:
//поймал краш - вместо InstagramImage получил строку, думаю есть случай, когда получим и InstagramImage. Однозначно нужно исправить

- (void)updateWIthPhotosUrl:(InstagramImage*)photos
{
    NSString* temp = [photos isKindOfClass:[NSString class]] ? (NSString*)photos : photos.url;
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:temp]];
    [self.image sd_setImageWithURL:url];
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    self.viewAllLabel.hidden = YES;
}

- (void)updateLastItem
{
    self.image.backgroundColor = [UIColor whiteColor];
    self.image.layer.borderColor = [UIColor bs_colorWithHexString:@"#929AB0"].CGColor;
    self.image.layer.borderWidth = 1;
    self.image.image = nil;
    self.viewAllLabel.hidden = NO;
}


#pragma mark - Lazy Load

- (UIImageView*)image
{
    if (!_image)
    {
        _image = [UIImageView new];
        _image.layer.cornerRadius = 5;
        _image.clipsToBounds = YES;
        _image.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_image];
        
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _image;
}

- (UILabel*)viewAllLabel
{
    if (!_viewAllLabel)
    {
        _viewAllLabel = [UILabel new];
        [_viewAllLabel setText:@"View all"];
        _viewAllLabel.font = FONT_SF_DISPLAY_MEDIUM(18);
        [_viewAllLabel setTextColor:[UIColor bs_colorWithHexString:@"#3E4657"]];
        [self.image addSubview:_viewAllLabel];
        [_viewAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.image);
        }];
    }
    return _viewAllLabel;
}

@end
