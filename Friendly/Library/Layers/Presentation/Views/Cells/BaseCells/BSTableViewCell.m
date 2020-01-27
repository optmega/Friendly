//
//  BSTableViewCell.m
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "BSTableViewCell.h"

@implementation BSTableViewCell

- (void)updateWithModel:(id)model
{
    if ([model isKindOfClass:[NSString class]])
    {
        self.textLabel.text = model;
    }
}


@end
