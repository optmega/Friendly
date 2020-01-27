//
//  FRCreateEventAgeCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventAgeCellViewModel.h"

@implementation FRCreateEventAgeCellViewModel

- (NSAttributedString*)attributedTitle
{
    if (!self.isRequired)
    {
        return [[NSAttributedString alloc]initWithString:self.title];
    }
    
    NSMutableAttributedString* attribString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ *", self.title]];
    [attribString setAttributes:@{NSForegroundColorAttributeName : [UIColor bs_colorWithHexString:@"#FF6868"]} range:NSMakeRange(self.title.length, 2)];
    
    return attribString;
}

@end
