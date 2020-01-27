//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsInteractor.h"
#import "FRSettingsTransport.h"
#import "FRInterestsModel.h"
#import "FRRecomendedUserModel.h"

@interface FRAddInterestsInteractor ()


@end

@implementation FRAddInterestsInteractor

- (void)loadData
{
    [self.output showHudWithType:FRAddInterestsHudTypeShowHud title:nil message:nil];
    [FRSettingsTransport getAllInterestsWithSuccess:^(FRInterestsModels *models) {

        [self.output showHudWithType:FRAddInterestsHudTypeHideHud title:nil message:nil];
        [self.output dataLoadedWithModel:models];
        
    } failure:^(NSError *error) {

        [self.output showHudWithType:FRAddInterestsHudTypeHideHud title:nil message:nil];
        [self.output showHudWithType:FRAddInterestsHudTypeError title:@"Error" message:error.localizedDescription];

    }];
    
}

- (void)selectedContinue
{
    if (self.interests.count<3)
    {
        [self.output showHudWithType:FRAddInterestsHudTypeError title:@"Error" message:@"Please selected three or more interests"];
        return;
    }
    
    
    [self.output showHudWithType:FRAddInterestsHudTypeShowHud title:nil message:nil];
    
    
    NSMutableArray* tagId = [NSMutableArray array];
    [self.interests enumerateObjectsUsingBlock:^(FRInterestsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagId addObject:obj.id];
    }];
    
    [FRSettingsTransport updateCurrentUserFavoritesInterests:tagId success:^(FRInterestsModels *models) {
//        [self.output showHudWithType:FRAddInterestsHudTypeHideHud title:nil message:nil];
//
//        [self.output goNextWithInterests:self.interests];
        [self goNext:self.interests];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRAddInterestsHudTypeError title:@"Error" message:error.localizedDescription];

    }];
}


- (void)goNext:(NSArray*)interest {
    [FRSettingsTransport recomendedUsersWithSuccess:^(FRRecomendedUserModels *users) {
        [self.output showHudWithType:FRAddInterestsHudTypeHideHud title:nil message:nil];
        
        if (users.recommended_users.count) {
            [self.output goNextWithUsers:users interests:interest];
        } else {
            [self.output goProfileSettingsWithInterests:interest];
        }
        
//        [self.output dataLoadedWithModel:users];
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRAddInterestsHudTypeError title:@"Error" message:error.localizedDescription];
    }];
}

- (void)addTag:(NSString*)tag
{
    tag = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!tag.length) {
        return;
    }
    tag = [tag stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    [self.output showHudWithType:FRAddInterestsHudTypeShowHud title:nil message:nil];
    [FRSettingsTransport addNewInterestWithTitle:tag success:^(FRInterestsModel* interests) {
        
        [self.output showHudWithType:FRAddInterestsHudTypeHideHud title:nil message:nil];
        [self selectetInterest:interests];
        [self.output addedInterests:interests];

    } failure:^(NSError *error) {
        [self.output showHudWithType:FRAddInterestsHudTypeError title:@"Error" message:error.localizedDescription];
    }];
}

- (void)selectetInterest:(FRInterestsModel*)model
{
    if ([self.interests containsObject:model])
    {
        [self.interests removeObject:model];
    }
    else
    {
        [self.interests addObject:model];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedInterests" object:@(self.interests.count)];
}

- (NSMutableArray*)interests
{
    if (!_interests)
    {
        _interests = [NSMutableArray array];
    }
    return _interests;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
