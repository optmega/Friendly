//
//  FRTextTableViewCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewTextCell.h"

@interface FREventPreviewTextCell()

@property (strong, nonatomic) UILabel* infoTextLabel;

@end

@implementation FREventPreviewTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self infoTextLabel];
    }
    return self;
}


- (void) updateWithModel:(FREventPreviewTextCellViewModel*)model
{
    self.infoTextLabel.text = model.infoText;
}


#pragma mark - LazyLoad

-(UILabel*) infoTextLabel
{
    if (!_infoTextLabel)
    {
        _infoTextLabel = [UILabel new];
        [_infoTextLabel setFont:FONT_SF_DISPLAY_REGULAR(17)];
        [_infoTextLabel setTextColor:[UIColor bs_colorWithHexString:@"606671"]];
     //   [_infoTextLabel setText:@"It's been 2 months and I am yet to try Australia's famouse draft beers. Get your hipster on and come join me for some craft beer tasting and a one of Sydney's hotest bars/clubs.\n\nFacebook invites are open so feel free to invite your friends but hurry only 6 spots open."];
        [_infoTextLabel sizeToFit];
      //  _infoTextLabel.adjustsFontSizeToFitWidth = YES;
        _infoTextLabel.numberOfLines=0;
        [self.contentView addSubview:_infoTextLabel];
        [_infoTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.bottom.equalTo(self.contentView).offset(-40);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return _infoTextLabel;
}

@end
