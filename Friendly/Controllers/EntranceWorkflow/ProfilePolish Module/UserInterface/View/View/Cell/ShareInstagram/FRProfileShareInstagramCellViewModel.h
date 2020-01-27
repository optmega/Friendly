//
//  FRProfileShareInstagramCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRProfileShareInstagramCellViewModelDelegate <NSObject>

- (void)connectSelected;
- (void)showPreviewWithImage:(UIImage*)image;

@end

@interface FRProfileShareInstagramCellViewModel : NSObject

@property (nonatomic, weak) id<FRProfileShareInstagramCellViewModelDelegate>delegate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, strong) NSArray* photos;
@property (nonatomic, assign, readonly) CGFloat heightCell;
@property (nonatomic, assign) BOOL isSelfInstagramConnected;
@property (nonatomic, strong) NSString* instagram_media_count;
@property (nonatomic, strong) NSString* instagram_username;

- (void)connectSelected;
- (void)showPreviewWithImage:(UIImage*)image;

@end
