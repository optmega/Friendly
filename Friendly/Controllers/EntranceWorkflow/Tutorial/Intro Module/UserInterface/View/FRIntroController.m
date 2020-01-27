//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroController.h"
#import "FRIntroDataSource.h"

@implementation FRIntroController

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

- (void)updateDataSource:(FRIntroDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

@end
