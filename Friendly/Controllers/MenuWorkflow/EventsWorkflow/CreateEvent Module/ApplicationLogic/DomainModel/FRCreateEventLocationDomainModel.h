//
//  FRCreateEventLocationDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 17.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRCreateEventLocationDomainModel : NSObject

@property (nonatomic, strong) UIImage* locationPhoto;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* placeName;


@end
