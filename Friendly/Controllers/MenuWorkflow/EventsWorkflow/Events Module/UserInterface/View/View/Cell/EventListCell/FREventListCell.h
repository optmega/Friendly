//
//  FREventListCell.h
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FREventListCellViewModel.h"

@class FREventModel;

@protocol FREventListCollevtionCellDelegate <NSObject>

- (void)selectEvent:(FREventModel*)event frame:(CGRect)attributes image:(UIImage*)image;

@end


@interface FREventListCell : BSBaseTableViewCell

@property (nonatomic, weak) id<FREventListCollevtionCellDelegate> delegate;

- (void)updateWithModel:(FREventListCellViewModel*)model;

@end
