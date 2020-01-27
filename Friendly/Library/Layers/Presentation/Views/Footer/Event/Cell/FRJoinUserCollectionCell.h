//
//  FRJoinUserCollectionCell.h
//  Friendly
//
//  Created by Sergey Borichev on 16.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventModel.h"

@interface FRJoinUserCollectionCell : UICollectionViewCell

- (void)updateWithModel:(FRJoinUser*)model;

@end


@interface FRJoinUserEmptyCollectionCell : UICollectionViewCell

- (void)updateWithCount:(NSInteger)count;

@end
