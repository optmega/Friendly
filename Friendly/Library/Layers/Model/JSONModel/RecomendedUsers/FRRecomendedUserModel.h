//
//  FRRecomendedUserModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserModel.h"

@interface FRRecomendedUserModels : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRUserModel> *recommended_users;

@end
