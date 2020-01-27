//
//  FRMyProfileIconCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@protocol FRMyProfileIconCellViewModelDelegate <NSObject>

- (void)changeStatus:(NSInteger)status;
- (void)presentAddMobileController;
- (void)presentInviteFriendsController;

@end

@interface FRMyProfileIconCellViewModel : NSObject

@property (nonatomic, strong) id<FRMyProfileIconCellViewModelDelegate> delegate;
@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, assign) BOOL isOpen;

- (void)changeStatus:(NSInteger)status;
- (void)presentAddMobileController;
- (void)presentInviteFriendsController;
@end
