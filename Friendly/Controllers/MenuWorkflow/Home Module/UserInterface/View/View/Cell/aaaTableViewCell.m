//
//  aaaTableViewCell.m
//  Friendly
//
//  Created by Dmitry on 19.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "aaaTableViewCell.h"
@interface aaaTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subt;

@property (weak, nonatomic) IBOutlet UILabel *context;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
@implementation aaaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
