//
//  FRCreateEventTextViewCell.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FRCreateEventTextViewCellViewModel.h"

@class FRCreateEventTextViewCell;

@protocol FRCreateEventTextViewCellDelegate <NSObject>

- (void)textEditing:(UITableViewCell*)cell;

@end

@interface FRCreateEventTextViewCell : BSBaseTableViewCell

@property (nonatomic, weak) id<FRCreateEventTextViewCellDelegate> delegate;

@end
