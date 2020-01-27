//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileInteractor.h"
#import "FRSettingsTransport.h"
#import "FRProfileDomainModel.h"
#import "FRUploadImage.h"

@implementation FREditProfileInteractor

- (void)loadData
{
    [self.output dataLoaded];
}

- (void)updateUserProfile:(FRProfileDomainModel*)model
{
    if (!model)
    {
        return;
    }
    
    [self.output showHudWithType:FREditProfileHudTypeShowHud title:nil message:nil];
    
    
    if (model.photoImage)
    {
        [FRUploadImage uploadImage:model.photoImage complite:^(NSString *imageUrl) {
            model.photo = imageUrl;
            [self _uploadWallImageForModel:model];
        } failute:^(NSError *error) {
            [self.output showHudWithType:FREditProfileHudTypeError title:@"Error" message:error.localizedDescription];
        }];
        return;
    }
    [self _uploadWallImageForModel:model];
    
}


- (void)_uploadWallImageForModel:(FRProfileDomainModel*)model
{
    if (model.wallImage)
    {
        [FRUploadImage uploadImage:model.wallImage complite:^(NSString *imageUrl) {
            model.wall = imageUrl;
            [self _updateUserProfile:model];
        } failute:^(NSError *error) {
            [self.output showHudWithType:FREditProfileHudTypeError title:@"Error" message:error.localizedDescription];
        }];
        return;
    }
    
    [self _updateUserProfile:model];
}

- (void)_updateUserProfile:(FRProfileDomainModel*)model
{
    [FRSettingsTransport updateProfile:model success:^{
        
        [self.output showHudWithType:FREditProfileHudTypeShowHud title:nil message:nil];
        [self.output profileUpdated];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FREditProfileHudTypeError title:@"Error" message:error.localizedDescription];
        
    }];
}

@end
