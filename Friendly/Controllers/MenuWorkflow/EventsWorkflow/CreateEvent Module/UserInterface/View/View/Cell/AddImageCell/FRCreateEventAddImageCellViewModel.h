//
//  FRCreateEventAddImageCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@protocol FRCreateEventAddImageCellViewModelDelegate <NSObject>

- (void)selectedClose;
- (void)selectedUploadPhoto;
- (void)selectedSave;

@end

@interface FRCreateEventAddImageCellViewModel : NSObject

@property (nonatomic, weak) id<FRCreateEventAddImageCellViewModelDelegate> delegate;
@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, assign) BOOL isShowSave NS_DEPRECATED_IOS(8, 8);
@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) NSString* thumbnail;

- (void)close;
- (void)uploadPhoto;
- (void)save;

- (void)updateImage:(UIImageView*)imageView;

@end
