//
//  FReventImageSelectPreviewCollectionViewCell.m
//  Friendly
//
//  Created by User on 30.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FReventImageSelectPreviewCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface FReventImageSelectPreviewCollectionViewCell()


@end

@implementation FReventImageSelectPreviewCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self previewView];
    }
    return self;
}

-(void)updateWithUrl:(NSString*)url
{
    [self.previewView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Questionair - header"]];
}

-(UIImageView*) previewView
{
    if (!_previewView)
    {
        _previewView = [UIImageView new];
        [_previewView setBackgroundColor:[UIColor clearColor]];
        _previewView.layer.cornerRadius = 7;
        _previewView.contentMode = UIViewContentModeScaleAspectFill;
        _previewView.clipsToBounds = YES;
        _previewView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        [_previewView addGestureRecognizer:tap];
//        [_previewView setImage:];
        [self.contentView addSubview:_previewView];
        [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return _previewView;
}


@end
