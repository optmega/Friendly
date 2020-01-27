//
//  FRPhotosMutualFriendCell.h
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FRPhotosMutualFriendCellViewModel.h"

@interface FRPhotosMutualFriendCell : BSBaseTableViewCell

- (void)updateWithModel:(FRPhotosMutualFriendCellViewModel*)model;

@end
