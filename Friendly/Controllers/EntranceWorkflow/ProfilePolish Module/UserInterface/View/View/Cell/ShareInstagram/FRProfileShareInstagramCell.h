//
//  FRProfileShareInstagramCell.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "FRProfileShareInstagramCellViewModel.h"

@interface FRProfileShareInstagramCell : BSBaseTableViewCell

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIButton* connectButton;

@end
