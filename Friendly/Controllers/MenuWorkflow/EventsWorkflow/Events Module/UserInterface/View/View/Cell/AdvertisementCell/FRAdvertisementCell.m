//
//  FRAdvertisementCell.m
//  Friendly
//
//  Created by Sergey Borichev on 29.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAdvertisementCell.h"


@interface FRAdvertisementCell ()

@property (nonatomic, strong) UIView* bannerView;
@property (nonatomic, strong) FRAdvertisementCellViewModel* model;

@end

@implementation FRAdvertisementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        self.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self bannerView];
    }
    return self;
}

- (void)updateWithModel:(FRAdvertisementCellViewModel*)model
{
    self.model = model;
}

#pragma mark - ADBannerViewDelegate


#pragma mark - LazyLoad



@end
