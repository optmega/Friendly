//
//  FREventExtensionAdCell.m
//  Friendly
//
//  Created by Sergey on 12.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventExtensionAdCell.h"

@interface FREventExtensionAdCell ()


@end

@implementation FREventExtensionAdCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentForEvent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.bottom.equalTo(self.mas_centerY).offset(0);
        }];
        
        [self contentAdView];
        self.contentAdView.backgroundColor = [UIColor bs_colorWithHexString:@"#E8EBF1"];
        self.contentView.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        self.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
    }
    
    return self;
}



- (UIView*)contentAdView
{
    if (!_contentAdView)
    {
        _contentAdView = [[[NSBundle mainBundle] loadNibNamed:@"FRAdvertisementFBView" owner:nil options:nil] lastObject];
                          
        [self.contentView addSubview:_contentAdView];
        [_contentAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.top.equalTo(self.contentForEvent.mas_bottom);
        }];
    }
    return _contentAdView;
}

@end
