//
//  BSBaseTableViewCell.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol BSModelTransfer <NSObject>

@required

- (void)updateWithModel:(id)model;

@optional

- (id)model;

@end

@interface BSBaseTableViewCell : UITableViewCell <BSModelTransfer>

@end
