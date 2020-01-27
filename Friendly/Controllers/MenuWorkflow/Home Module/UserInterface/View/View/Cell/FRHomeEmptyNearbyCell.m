//
//  FRHomeEmptyNearbyCell.m
//  Friendly
//
//  Created by Dmitry on 21.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHomeEmptyNearbyCell.h"

@interface FRHomeEmptyNearbyCell ()

@property (nonatomic, weak) IBOutlet UILabel* title;

@end

@implementation FRHomeEmptyNearbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addFriends.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.title sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
