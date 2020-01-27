//
//  FRMessagesPrivateRoomCell.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FRMessagesPrivateRoomCellViewModel.h"

@interface FRMessagesPrivateRoomCell : BSBaseTableViewCell

@property (nonatomic, strong) UIImageView* photoImage;
@property (nonatomic, strong) UIImageView* statusImage;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UILabel* dateLabel;

@end
