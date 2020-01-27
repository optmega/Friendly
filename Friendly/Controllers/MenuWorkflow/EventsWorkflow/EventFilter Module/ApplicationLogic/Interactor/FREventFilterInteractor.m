//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterInteractor.h"
#import "FRSettingsTransport.h"
#import "FREventFilterDomainModel.h"
#import "FREvent.h"

@interface FREventFilterInteractor ()

@property (nonatomic, strong) NSString* placeName;

@end
@implementation FREventFilterInteractor

- (void)loadData
{
    
    [self.output dataLoaded:[FRUserManager sharedInstance].currentUser.filter];
    
    self.placeName = [FRUserManager sharedInstance].currentUser.filter.placeName;
    [FRSettingsTransport filterSuccess:^(Filter* respons) {
        
        [self.output dataLoaded:respons];

    } failure:^(NSError *error) {

    }];
}

- (void)updateFilter:(FREventFilterDomainModel*)filter
{    [self.output showHudWithType:FREventFilterHudTypeShowHud title:nil message:nil];

    
    BOOL locationUpdated = false;
    
    if ( filter.place_name &&  ![filter.place_name isEqualToString:self.placeName]) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        NSArray<FREvent*>* events = [FREvent MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"way < %d", 60000] inContext:context];
        
        [events enumerateObjectsUsingBlock:^(FREvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj MR_deleteEntityInContext:context];
        }];
        
        [context MR_saveToPersistentStoreAndWait];
        locationUpdated = true;
    }
    [FRSettingsTransport updateFilterWithGender:filter success:^(id respons) {
        
        [self.output showHudWithType:FREventFilterHudTypeHideHud title:nil message:nil];
        [self.output close];
        
//        if (locationUpdated) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Location update" object:nil];
//        }
    } failure:^(NSError *error) {
        
        [self.output showHudWithType:FREventFilterHudTypeError title:FRLocalizedString(@"Error", nil) message:error.localizedDescription];

    }];
}

@end
