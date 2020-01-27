//
//  FRPlaceDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPlaceDomainModel.h"


static const struct
{
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *address;
    __unsafe_unretained NSString *google_place_id;
    
} FRPlaceParametr =
{
  
    .name               = @"name",
    .address            = @"address",
    .google_place_id    = @"google_place_id",

};



@implementation FRPlaceDomainModel


- (NSDictionary*)domainModelDictionary
{
    return @{
           
             FRPlaceParametr.name : [NSObject bs_safeString:self.name],
          FRPlaceParametr.address : [NSObject bs_safeString:self.address],
  FRPlaceParametr.google_place_id : [NSObject bs_safeString:self.google_place_id],
             
             };
}

@end
