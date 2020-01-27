//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRProfileDomainModel;


@protocol FRProfilePolishDataSourceDelegate <NSObject>

- (void)emptyEventField:(NSString*)message;
- (void)selectedChangePhoto;
- (void)backSelected;
- (void)selectedConnectInstagram;

@end

@interface FRProfilePolishDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRProfilePolishDataSourceDelegate> delegate;

- (void)setupStorage;
- (FRProfileDomainModel*)profile;
- (void)updateUserPhoto:(UIImage*)image;

@end
