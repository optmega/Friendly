//
//  FRSearchByCategoryNearbyCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRSearchByCategoryNearbyCellViewModelDelegate <NSObject>

- (void)settingSelected;

@end

@interface FRSearchByCategoryNearbyCellViewModel : NSObject

@property (nonatomic, weak) id<FRSearchByCategoryNearbyCellViewModelDelegate> delegate;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString* content;
- (void)settingSelected;

@end
