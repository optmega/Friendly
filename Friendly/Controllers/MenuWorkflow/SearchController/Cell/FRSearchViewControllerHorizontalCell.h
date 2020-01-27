//
//  FRSearchViewControllerHorizontalCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRSearchViewControllerHorizontalCellDelegate <NSObject>

- (void)selectedCategory:(NSString*)category;

@end

@interface FRSearchViewControllerHorizontalCell : UITableViewCell

@property (strong, nonatomic) NSArray* dataArray;
@property (nonatomic, weak) id<FRSearchViewControllerHorizontalCellDelegate> delegate;

@end
