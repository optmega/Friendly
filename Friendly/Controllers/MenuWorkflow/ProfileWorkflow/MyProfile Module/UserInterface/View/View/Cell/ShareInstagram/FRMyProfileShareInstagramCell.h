//
//  FRMyProfileShareInstagramCell.h
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FRProfileShareInstagramCellViewModel.h"

@protocol FRMyProfileShareInstagramCellDelegate <NSObject>

-(void)connectInstagram;

@end

@interface FRMyProfileShareInstagramCell : BSBaseTableViewCell

@property (weak, nonatomic) id<FRMyProfileShareInstagramCellDelegate> delegate;
- (void)updateWithModel:(FRProfileShareInstagramCellViewModel*)model;

@end
