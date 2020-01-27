//
//  FREventPreviewAttendingSmallCollectionCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 13.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewAttendingSmallCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FREventPreviewAttendingSmallCollectionCell()

@property (strong, nonatomic) UIImageView* smallAvatar;

@end

@implementation FREventPreviewAttendingSmallCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      //  self.autoresizesSubviews = YES;
        [self smallAvatar];    }
    return self;
}

- (void) updateWithModel:(FRMemberUser*)model
{
        NSURL* url = [[NSURL alloc]initWithString:[NSObject bs_safeString:model.photo]];
        [self.smallAvatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}

 
#pragma mark - LazyLoad

-(UIImageView*) smallAvatar
{
    if (!_smallAvatar)
    {
        _smallAvatar = [UIImageView new];
        _smallAvatar.layer.cornerRadius = 14;
        _smallAvatar.clipsToBounds = YES;
//        _smallAvatar.layer.borderWidth = 2;
        _smallAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [_smallAvatar setBackgroundColor:[UIColor whiteColor]];
        
        UIView* whiteBorder = [UIView new];
        whiteBorder.backgroundColor = [UIColor whiteColor];
        whiteBorder.layer.cornerRadius = 16;
        
        [self.contentView addSubview:whiteBorder];
        
        [whiteBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.height.equalTo(@32);
//            make.left.right.equalTo(self.contentView);
        }];
        
        
        [whiteBorder addSubview:_smallAvatar];
        [_smallAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(whiteBorder);
            make.width.height.equalTo(@28);
//            make.left.right.equalTo(self.contentView);
        }];
    }
    return _smallAvatar;
}

@end
