//
//  BSBaseTableViewCell.m
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@implementation BSBaseTableViewCell

- (void)updateWithModel:(id)model
{
    NSString * reason = [NSString stringWithFormat:@"cell %@ should implement %@: method\n",
                         NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSException * exc =
    [NSException exceptionWithName:@"TableView API exception"
                            reason:reason
                          userInfo:nil];
    [exc raise];
}

- (id)model
{
    return nil;
}

@end
