//
//  FRSearchViewControllerRelatedCategoryCell.h
//  Friendly
//
//  Created by Jane Doe on 4/21/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRSearchViewControllerRelatedCategoryCell : UITableViewCell
@property (nonatomic, copy, readonly) NSString *category;
-(void)updateWithId:(NSString*)category_id andCounter:(NSString*)count;

@end
