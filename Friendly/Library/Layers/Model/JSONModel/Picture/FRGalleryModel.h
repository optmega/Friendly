//
//  FRPictureModel.h
//  Friendly
//
//  Created by Jane Doe on 5/19/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRPictureModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* thumbnail_url;
@property (nonatomic, strong) NSString<Optional>* image_url;
@property (nonatomic, strong) NSString<Optional>* category_id;
@property (nonatomic, strong) NSString<Optional>* id;

@end

@protocol FRPictureModel <NSObject>
@end


@interface FRGalleryModel : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRPictureModel>* pictures;

@end

@protocol FRGalleryModel <NSObject>
@end

