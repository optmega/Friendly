//
//  FRInterestsModel.h
//  Friendly
//
//  Created by Sergey Borichev on 02.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FRInterestsModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* is_mutual;

@end

@protocol FRInterestsModel <NSObject>
@end


@interface FRInterestsModels : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRInterestsModel>* interests;

@end