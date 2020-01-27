//
//  FRUserProfileInstagramPhotosCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRUserProfileInstagramPhotosCellViewModelDelegate <NSObject>

-(void)connectInstagram;
- (void)showPreviewWithImage:(UIImage*)image;

@end

@interface FRUserProfileInstagramPhotosCellViewModel : NSObject

@property (nonatomic, assign) BOOL isPrivateMode;
@property (strong, nonatomic) NSArray* photos;
@property (nonatomic, assign, readonly) CGFloat heightCell;
@property (nonatomic, assign) BOOL isSelfInstagramConnected;
@property (nonatomic, strong) NSString* instagram_media_count;
@property (nonatomic, strong) NSString* instagram_username;
@property (weak, nonatomic) id<FRUserProfileInstagramPhotosCellViewModelDelegate> delegate;
- (void)connectInstagram;
- (void)showPreviewWithImage:(UIImage*)image;
- (NSString*)title;
@property (strong, nonatomic) NSString* userID;
@end
