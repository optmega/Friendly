//
//  FRSearchViewControllerDiscoverPeopleCollectionCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 22.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerDiscoverPeopleCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FRSearchViewControllerDiscoverPeopleCollectionCell()

@property (strong, nonatomic) UIImageView* avatarImage;

@end

@implementation FRSearchViewControllerDiscoverPeopleCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self avatarImage];
//        [self.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    }
    return self;
}

-(void)updateWithPhoto:(NSString*)photo
{
   NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:photo]];
    [self.avatarImage sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}


#pragma mark - LazyLoad

-(UIImageView*) avatarImage
{
    if (!_avatarImage)
    {
        _avatarImage = [UIImageView new];
        _avatarImage.layer.cornerRadius = 25;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImage.layer.borderWidth = 2;
        [_avatarImage setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:_avatarImage];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@50);
            make.left.right.equalTo(self.contentView);
        }];
    }
    return _avatarImage;
}

@end
