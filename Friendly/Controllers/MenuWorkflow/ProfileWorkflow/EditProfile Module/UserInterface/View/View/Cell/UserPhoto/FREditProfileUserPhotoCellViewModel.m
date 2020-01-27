//
//  FREditProfileUserPhotoCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREditProfileUserPhotoCellViewModel.h"

@implementation FREditProfileUserPhotoCellViewModel

+ (instancetype)initWithModel:(UserEntity *)model
{
    FREditProfileUserPhotoCellViewModel* viewModel = [FREditProfileUserPhotoCellViewModel new];
    [viewModel setUserModel:model];
                                                      
    return viewModel;
}

- (void)changeUserPhoto
{
    [self.editDelegate changeUserPhoto];
}

- (void)changeWallPhoto
{
    [self.editDelegate changeWallPhoto];
}

- (void)saveSelected
{
    [self.editDelegate saveSelected];
}

- (void)settingSelected
{
    [self.editDelegate settingSelected];
}

@end
