//
//  FRCreateEventLocationSelectViewController.h
//  Friendly
//
//  Created by Jane Doe on 3/29/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventLocationPlaceModel.h"
#import "FRBaseVC.h"

@protocol FRCreateEventLocationDelegate <NSObject>

-(void) selectedLocation:(FRCreateEventLocationPlaceModel*)returnModel;

@end

@interface FRCreateEventLocationSelectViewController : FRBaseVC

@property (nonatomic, weak) id<FRCreateEventLocationDelegate> delegate;

@end
