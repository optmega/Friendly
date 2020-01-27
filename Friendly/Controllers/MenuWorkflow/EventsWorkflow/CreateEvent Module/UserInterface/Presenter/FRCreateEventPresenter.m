//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventPresenter.h"
#import "FRCreateEventDataSource.h"
#import "BSHudHelper.h"
#import "FRCreateEventCategoryViewController.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FRCreateEventAgesViewController.h"
#import "FRCreateEventGenderViewController.h"
#import "FRCreateEventOpenSlotsViewController.h"
#import "FRCreateEventTimeViewControllerNative.h"
#import "FRCreateEventDateViewControllerNative.h"
#import "FRCreateEventLocationPlaceModel.h"
#import "FRCalendarManager.h"

@class FRPictureModel;

@class FRCreateEventLocationPlaceModel;

@interface FRCreateEventPresenter () <FRCreateEventDataSourceDelegate>


@property (nonatomic, strong) FRCreateEventDataSource* tableDataSource;
@property (nonatomic, strong) NSArray* usersToInvite;


@end

@implementation FRCreateEventPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRCreateEventDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRCreateEventViewInterface>*)userInterface event:(FREventModel*)event
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadDataWithEvent:event];
    
    if (event)
    {
        [self.userInterface updateWithType:FRCreateEventEdit];
    }
    else
    {
        [self.userInterface updateWithType:FRCreateEventCreate];
    }
}

- (void)createdEvent:(FREvent*)event
{
    [self showHudWithType:FRCreateEventHudTypeShowHud title:nil message:nil];
    if (event)
    {
//        [[FRCalendarManager sharedInstance] addEvent:event fromController:self.userInterface complitionBlock:^{
//
//            BSDispatchBlockAfter(1, ^{
//            
//                BSDispatchBlockToMainQueue(^{
//                    [self showHudWithType:FRCreateEventHudTypeHideHud title:nil message:nil];
//                    [self.wireframe dismissCreateEventController];
//                });
//            });
//            
//        }];
//        
        return;
    }
    [self showHudWithType:FRCreateEventHudTypeHideHud title:nil message:nil];
    [self.wireframe dismissCreateEventControllerAndDelete];
}

- (void)deleteEvent
{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:FRLocalizedString(@"Warning", nil)
                                message:FRLocalizedString(@"Are you sure you want to delete this event?", nil)
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction: [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil)
                                               style:UIAlertActionStyleDefault
                                             handler:nil ]];
    [alert addAction:[UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.interactor deleteEvent];

    }]];
    
    [self.userInterface presentViewController:alert animated:YES completion:nil];
}

- (void)inviteUsers {
    [self.wireframe showFBInviteDialog];
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)dataLoadedWithEvent:(FREvent*)model
{
    [self.tableDataSource setupStorageWithEvent:model];
}

- (void)showHudWithType:(FRCreateEventHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)updateLocationWithDomainModel:(FRCreateEventLocationDomainModel*)domainModel
{
    [self.tableDataSource updateLocation:domainModel];
}

- (void)updateInviteSection:(FREventFeatureModel*)model {
    [self.tableDataSource updateFeature:model];
}

- (void)showVerifyAlert:(NSString*)alert
{
    [self.wireframe showVerifyAlert:alert];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissCreateEventController];
}

- (void)updateEventSelected
{
    [self.tableDataSource verifyFields];
  //  [self createEventSelected];
}

- (void)createEventSelected
{
    [self.interactor createEvent:[self.tableDataSource event] usersToInvite:self.usersToInvite];
}

- (void)inviteFriendsSelectedWith:(NSString *)eventId
{
    [self.wireframe presentInviteFriendsVCWith:eventId];
}

- (void)categorySelected
{
    [self.wireframe presentCategoryVC];
}

- (void)partnerHostingSelectedWith:(NSString*)eventId
{
    [self.wireframe presentInviteCoHostVCWith:eventId];
}

- (void)agesSelected
{
        NSArray* ages = [self.tableDataSource ages];
        [self.wireframe presentAgesControllerWithAgesMin:ages.firstObject max:ages.lastObject];    
}

- (void)genderSelected
{
    [self.wireframe presentGenderControllerWithGender:[self.tableDataSource gender]];
}

- (void)openSlotsSelected
{
    [self.wireframe presentOpenSlotsControllerWithSlots:[self.tableDataSource openSlots]];
}

- (void)timeSelected
{
    if ([self.tableDataSource eventTime] != nil)
    {
        [self.wireframe presentTimeControllerWithTime:[self.tableDataSource eventTime]];
    }
    else
    {
        [self.wireframe presentTimeControllerWithTime:[self.tableDataSource eventTime]];
    }
}

- (void)dateSelected
{
    [self.wireframe presentDateControllerWithDate:[self.tableDataSource evendDate]];
}

- (void)locationSelected
{
    [self.wireframe presenLocationVC];
}


- (void)imageSelected:(UIImage*)image
{
    [self.tableDataSource updateEventImage:image];
}


#pragma mark - FRCreateEventAgesViewControllerDelegate

- (void)updateAgesMin:(NSInteger)min max:(NSInteger)max
{
    [self.tableDataSource updateAgesMin:min max:max];
}


#pragma mark - FRCreateEventGenderViewControllerDelegate

- (void)selectedGender:(FRGenderType)gender
{
    [self.tableDataSource updateGender:gender];
}

- (void)selectedCategory:(NSString *)category andId:(NSString *)id
{
    [self.tableDataSource updateCategory:category andId:id];
    
}

#pragma mark - FRCreateEventInviteFriendsViewControllerDelegate

- (void)selectedFriends:(NSArray*)friends withIdArray:(NSArray*)friendsId;
{
    self.usersToInvite = friendsId;
    [self.tableDataSource updateInviteUsers:friends];
}

#pragma mark - FRCreateEventInviteToCoHostViewControllerDelegate

- (void)selectedPartnerWithId:(NSString*)partnerId andName:(NSString*)partnerName
{
    [self.tableDataSource updateCoHost:partnerId :partnerName];
}

#pragma mark - FRCreateEventOpenSlotsViewControllerDelegate

- (void)slotsUpdate:(NSInteger)slots
{
    [self.tableDataSource updateOpenSlots:slots];
}


#pragma mark - FRCreateEventTimeViewControllerDelegate

- (void)didSelectTime:(NSDate*)time
{
    [self.tableDataSource updateTime:time];
}

#pragma mark -

- (void)selectedLocation:(FRCreateEventLocationPlaceModel*)returnModel
{
    [self.interactor lookPlaceWithId:returnModel.placeID];
    
//    [self.tableDataSource updateLocation:returnModel];
}

- (void)selectedDate:(NSDate*)date
{
    [self.tableDataSource updateDate:date];
}

-(void)selectedPhoto:(UIImage*)image
{
    [self imageSelected:image];
}

-(void)selectedPhoto:(UIImage*)image with:(FRPictureModel*)model
{
    [self.tableDataSource updateEventImage:image with:model];
}

#pragma mark - Data source Delegate

- (void)showPhotoPicker
{
    [self.wireframe presentSelectEventImageVC];
//    [self.wireframe presentPhotoPickerController];
}

- (void)emptyEventField:(NSString *)string
{
  //  [BSHudHelper showHudWithType:BSHudTypeError view:self.userInterface title:@"You need to fill in the following fields first:" message:string];
}


@end
