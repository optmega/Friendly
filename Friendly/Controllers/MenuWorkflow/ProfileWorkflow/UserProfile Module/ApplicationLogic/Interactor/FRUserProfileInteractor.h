//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileInteractorIO.h"

@interface FRUserProfileInteractor : NSObject <FRUserProfileInteractorInput>

@property (nonatomic, weak) id<FRUserProfileInteractorOutput> output;
@property (nonatomic, strong) FRUserModel* userProfile;
@property (nonatomic, strong) UserEntity* user;


@end

