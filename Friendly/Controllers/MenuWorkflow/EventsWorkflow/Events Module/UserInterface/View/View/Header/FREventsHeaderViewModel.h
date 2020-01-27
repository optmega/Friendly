//
//  FREventsHeaderViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 12.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@protocol FREventsHeaderViewModelDelegate <NSObject>

- (void)showShowUserProfileSelected;
- (void)showFilterSelected;

@end

@interface FREventsHeaderViewModel : NSObject

@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) NSString* searchContent;
@property (nonatomic, weak) id<FREventsHeaderViewModelDelegate> delegate;
- (void)showUserProfileSelected;
- (void)showFilter;

@end
