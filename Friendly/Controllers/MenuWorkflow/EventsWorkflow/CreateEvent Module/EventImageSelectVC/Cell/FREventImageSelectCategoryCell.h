//
//  FREventImageSelectCategoryCell.h
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FREventImageSelectCategoryCellDelegate <NSObject>

- (void) presentImagesVCWithCategory:(NSString*)category;

@end

@interface FREventImageSelectCategoryCell : UICollectionViewCell

@property (strong, nonatomic) UIButton* backView;
@property (strong, nonatomic) UILabel* name;
@property (weak, nonatomic) NSObject<FREventImageSelectCategoryCellDelegate>* delegate;

@end

