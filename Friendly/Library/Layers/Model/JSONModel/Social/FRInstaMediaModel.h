//
//  FRInstaMediaModel.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 02.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRInstaMediaModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* created_time;
@property (nonatomic, strong) NSDictionary<Optional>* images;

@end

@protocol FRInstaMediaModel <NSObject>

@end

@interface FRInstaMediaModels : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRInstaMediaModel>* data;

@end
