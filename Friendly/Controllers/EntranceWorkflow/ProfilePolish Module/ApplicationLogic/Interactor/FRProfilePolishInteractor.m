 //
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishInteractor.h"
#import "FRSettingsTransport.h"
#import "FRProfileDomainModel.h"
#import "FRInterestsModel.h"
#import "FRUploadImage.h"
#import "FRUserManager.h"
#import "FRSocialTransport.h"

@interface FRProfilePolishInteractor ()

@property (nonatomic, strong) NSArray* interests;

@end

@implementation FRProfilePolishInteractor

- (void)loadDataWithInterests:(NSArray*)interests
{
    self.interests = interests;
    [self.output dataLoaded];
}

- (void)updateUserProfile:(FRProfileDomainModel*)model
{
    if (!model)
    {
        return;
    }
    if ([FRUserManager sharedInstance].instaToken != nil) {
        [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
            //
        } failure:^(NSError *error) {
            //
        }];
    }

    
    [self.output showHudWithType:FRProfilePolishHudTypeShowHud title:nil message:nil];
    
    NSMutableString* interestsString = [NSMutableString string];
    [self.interests enumerateObjectsUsingBlock:^(FRInterestsModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [interestsString insertString:[NSString stringWithFormat:@"%@, ",obj.title] atIndex:interestsString.length];
    }];
    
    model.interests = [interestsString substringWithRange:NSMakeRange(0, interestsString.length - 2)];
    
    if (model.photoImage)
    {
        [FRUploadImage uploadImage:model.photoImage complite:^(NSString *imageUrl) {
            model.photo = imageUrl;
            [self _updateProfile:model];
        } failute:^(NSError *error) {
            
            BSDispatchBlockToMainQueue(^{
                [self.output showHudWithType:FRProfilePolishHudTypeError title:@"Error" message:error.localizedDescription];
            });
        }];
        
        return;
    }
    
    [self _updateProfile:model];
    
}

- (void)_updateProfile:(FRProfileDomainModel*)profile
{
    [FRSettingsTransport updateProfile:profile success:^{
        
        [self.output showHudWithType:FRProfilePolishHudTypeShowHud title:nil message:nil];
        [self.output profileUpdated];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRProfilePolishHudTypeError title:@"Error" message:error.localizedDescription];
        
    }];
}


@end
