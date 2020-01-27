//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatController.h"
#import "FRPrivateChatDataSource.h"

@implementation FRPrivateChatController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
      //  [self registerCellClass:[FRCell class] forModelClass:[FRCellViewModel class]];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDataSource:(FRPrivateChatDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

@end
