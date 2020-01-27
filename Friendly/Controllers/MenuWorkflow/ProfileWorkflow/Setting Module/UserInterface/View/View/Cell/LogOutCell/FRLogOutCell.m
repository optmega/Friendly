//
//  FRLogOutCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLogOutCell.h"
#import "FRSupportCellViewModel.h"


@implementation FRLogOutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setTitleColor:[UIColor bs_colorWithHexString:kPurpleColor]];
    }
    return self;
}

- (void)updateWithModel:(FRLogOutCellViewModel*)model
{
    FRSupportCellViewModel* modelSupport = [FRSupportCellViewModel new];
    modelSupport.title = model.title;
    modelSupport.subtitle = model.subtitle;
    [super updateWithModel:modelSupport];
}

@end
