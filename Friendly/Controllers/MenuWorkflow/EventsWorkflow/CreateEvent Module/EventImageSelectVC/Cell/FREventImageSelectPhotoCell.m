//
//  FREventImageSelectPhotoCell.m
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectPhotoCell.h"

@interface FREventImageSelectPhotoCell()


@end

@implementation FREventImageSelectPhotoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self backView];
    }
    return self;
}

-(void)presentImagesVC
{
//    [self.delegate presentImagesVCWithCategory:self.name.text];
}


#pragma mark - LazyLoad

-(UIImageView*) backView
{
    if (!_backView)
    {
        _backView = [UIImageView new];
        _backView.layer.cornerRadius = 7;
        _backView.clipsToBounds = YES;
        [_backView setBackgroundColor:[UIColor clearColor]];
        _backView.contentMode = UIViewContentModeScaleAspectFill;
//        [_backView addTarget:self action:@selector(presentImagesVC) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
        }];
    }
    return _backView;
}
@end
