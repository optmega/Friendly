//
//  FRProfilePolishHeaderCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 06.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@protocol FRProfilePolishHeaderCellViewModelDelegate <NSObject>

- (void)selectedChangePhoto;
- (void)selectedBack;

@end

@interface FRProfilePolishHeaderCellViewModel : NSObject

@property (nonatomic, weak) id<FRProfilePolishHeaderCellViewModelDelegate> delegate;
@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) UIImage* photo;

- (void)updateUserPhoto:(UIImageView*)imageView;
- (void)selectedChangePhoto;
- (void)selectedBack;

@end
