//
//  FRPlaceModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRPlaceModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* info;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* address;
@property (nonatomic, strong) NSString<Optional>* google_place_id;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* days_from_last_search;

@end

@interface FRPlaceIconModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* icon;

@end

@protocol FRPlaceIconModel <NSObject>

@end

@interface FRPlaceIconResultModel : JSONModel

@property (nonatomic, strong) NSDictionary<Optional>* result;

@end


@protocol FRPlaceModel <NSObject>
@end

@protocol FRPlaceIconResultModel <NSObject>

@end

@interface FRPlacesModel : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRPlaceModel>* places;

@end