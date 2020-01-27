//
//  FRCreateEventTextViewCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventTextViewCellViewModel.h"

@implementation FRCreateEventTextViewCellViewModel

- (void)changeText:(NSString*)text
{
    [self.delegate changeTextContent:text type:self.type];
}

@end
