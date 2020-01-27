//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRFilterModel, FREventFilterDomainModel;


@protocol FREventFilterDataSourceDelegate <NSObject>

@end

@interface FREventFilterDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FREventFilterDataSourceDelegate> delegate;

- (void)setupStorageWithFilter:(Filter*)model;
- (void)updateGender:(FRGenderType)type;
- (void)updateDate:(FRDateFilterType)type andText:(NSString*)text;
- (void)updateLocationWithLat:(NSString*)lat lon:(NSString*)lon name:(NSString*)name;
- (FRDateFilterType)dateType;
- (FRGenderType)genderType;
- (FREventFilterDomainModel*)filterModel;

@end
