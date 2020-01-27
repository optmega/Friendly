//
//  FRSearchUserModel.h
//  Friendly
//
//  Created by Sergey Borichev on 23.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRSearchUserModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* tags_in_common;
@property (nonatomic, strong) NSArray<Optional>* instagram_images;
@property (nonatomic, strong) NSString<Optional>* is_friend;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSArray<Optional>* mutual_friends;
@property (nonatomic, strong) NSString<Optional>* birthday;
@property (nonatomic, strong) NSString<Optional>* way;
@property (nonatomic, strong) NSString<Optional>* id;

@end

@protocol FRSearchUserModel <NSObject>
@end

@interface FRSearchUsers : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRSearchUserModel>* users;

@end
