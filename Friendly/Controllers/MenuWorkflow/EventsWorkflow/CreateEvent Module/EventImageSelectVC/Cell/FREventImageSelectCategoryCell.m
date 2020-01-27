//
//  FREventImageSelectCategoryCell.m
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectCategoryCell.h"
#import "FRCategoryManager.h"

@interface FREventImageSelectCategoryCell()

@end

@implementation FREventImageSelectCategoryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self backView];
        [self name];
    }
    return self;
}

-(void)presentImagesVC
{
    [self.delegate presentImagesVCWithCategory:[[FRCategoryManager getCategoryDictionary] objectForKey:self.name.text]];
}


#pragma mark - LazyLoad

-(UIButton*) backView
{
    if (!_backView)
    {
        _backView = [UIButton new];
        double size = ([UIScreen mainScreen].bounds.size.width-73)/3;
        _backView.layer.cornerRadius = size/2;
        _backView.clipsToBounds = YES;
        [_backView setBackgroundColor:[UIColor clearColor]];
        [_backView addTarget:self action:@selector(presentImagesVC) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-40);
            make.left.right.equalTo(self.contentView);
        }];
    }
    return _backView;
}

-(UILabel*) name
{
    if (!_name)
    {
        _name = [UILabel new];
        [_name setText:@"Name"];
        [_name setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_name setFont:FONT_PROXIMA_NOVA_MEDIUM(15)];
        [self.contentView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.backView.mas_bottom).offset(7);
        }];
    }
    return _name;
}

@end
