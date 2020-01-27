//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventWireframe.h"
#import "FRCreateEventInteractor.h"
#import "FRCreateEventVC.h"
#import "FRCreateEventPresenter.h"
#import "FRCreateEventCategoryViewController.h"
#import "FRCreateEventAgesViewController.h"
#import "FRCreateEventOpenSlotsViewController.h"
#import "FRCreateEventTimeViewControllerNative.h"
#import "FRCreateEventDateViewControllerNative.h"
#import "FRCreateEventGenderViewController.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FRCreateEventLocationSelectViewController.h"
#import "FRPhotoPickerController.h"
#import "FRCreateEventInviteToCoHostViewController.h"
#import "FREventImageSelectViewController.h"
#import "FRCreateEventInviteFriendsViewController.h"

@interface FRCreateEventWireframe ()

@property (nonatomic, weak) FRCreateEventPresenter* presenter;
@property (nonatomic, weak) UIViewController* presentedController;
@property (nonatomic, strong) FRPhotoPickerController* photoPickerController;
@property (nonatomic, assign) BOOL animation;

@end

@implementation FRCreateEventWireframe

- (void)presentCreateEventControllerFromNavigationController:(UIViewController*)nc event:(FREventModel*)eventModel animation:(BOOL)animation
{
    self.animation = animation;
    FREvent *event = nil;
    if ([eventModel isKindOfClass:[FREvent class]]) {
        event = (FREvent *)eventModel;
    }
    
    FRCreateEventVC* createEventController = [FRCreateEventVC new];
    createEventController.eventId = event.eventId;
    FRCreateEventInteractor* interactor = [FRCreateEventInteractor new];
    FRCreateEventPresenter* presenter = [FRCreateEventPresenter new];
    
    interactor.output = presenter;
    
    createEventController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:createEventController event:eventModel];
    
    BSDispatchBlockToMainQueue(^{
        [nc presentViewController:createEventController animated:animation completion:nil];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.createEventController = createEventController;
}

- (void)dismissCreateEventControllerAndDelete {
    [self dismissCreateEventController];
    if (self.animation)
    {
        [self.presentedController dismissViewControllerAnimated:true completion:nil];
    }
    
}

- (void)dismissCreateEventController
{
//    [self.presentedController popViewControllerAnimated:YES];
    [self.createEventController dismissViewControllerAnimated:self.animation completion:nil];
}

- (void)presentSelectEventImageVC
{
    FREventImageSelectViewController* imageSelectVC = [FREventImageSelectViewController new];
    imageSelectVC.createPresenter = self.presenter;
    [self.createEventController presentViewController:imageSelectVC animated:YES completion:nil];
}

- (void)presentInviteFriendsVCWith:(NSString *)eventId
{
    FRCreateEventInviteFriendsViewController* inviteFriendsVC = [FRCreateEventInviteFriendsViewController new];
    inviteFriendsVC.isVCForCreating = YES;
    inviteFriendsVC.delegate = (id<FRCreateEventInviteFriendsViewControllerDelegate>)self.presenter;
    inviteFriendsVC.eventId = eventId;
    
    [self.createEventController presentViewController:inviteFriendsVC animated:YES completion:nil];
}

- (void)presentInviteCoHostVCWith:(NSString*)eventId
{
    FRCreateEventInviteToCoHostViewController* inviteCoHostVC = [FRCreateEventInviteToCoHostViewController new];
    inviteCoHostVC.isVCForCreating = YES;
    inviteCoHostVC.eventId = eventId;
    inviteCoHostVC.selectPartnerDelegate = (id<FRCreateEventInviteToCoHostViewControllerDelegate>)self.presenter;
    
    [self.createEventController presentViewController:inviteCoHostVC animated:YES completion:nil];
}

- (void)presentCategoryVC
{
    FRCreateEventCategoryViewController* categoryVC = [FRCreateEventCategoryViewController new];
    categoryVC.delegate = (id<FRCreateEventCategoryDelegate>)self.presenter;
    [self.createEventController presentViewController:categoryVC animated:YES completion:nil];
}

- (void)presentAgesControllerWithAgesMin:(NSNumber*)min max:(NSNumber*)max
{
    FRCreateEventAgesViewController* agesVC = [FRCreateEventAgesViewController new];
    agesVC.delegate = (id<FRCreateEventAgesViewControllerDelegate>)self.presenter;
    [agesVC setAgeMin:min.integerValue max:max.integerValue];
    
    
    BSDispatchBlockToMainQueue(^{
        [self.createEventController presentViewController:agesVC animated:NO completion:nil];
    });
}

- (void)presentGenderControllerWithGender:(FRGenderType)gender
{
    FRCreateEventGenderViewController* genderVC = [FRCreateEventGenderViewController new];
    genderVC.genderType = gender;
    genderVC.delegate = (id<FRCreateEventGenderViewControllerDelegate>)self.presenter;

    [self.createEventController presentViewController:genderVC animated:NO completion:nil];
}

- (void)presentOpenSlotsControllerWithSlots:(NSInteger)slots
{
    BSDispatchBlockToMainQueue(^{
        
        FRCreateEventOpenSlotsViewController* openSlotsVC = [FRCreateEventOpenSlotsViewController new];
        openSlotsVC.slotsCount = slots;
        openSlotsVC.delegate = (id<FRCreateEventOpenSlotsViewControllerDelegate>)self.presenter;
        [self.createEventController presentViewController:openSlotsVC animated:NO completion:nil];
    });
    
}

- (void)presentTimeControllerWithTime:(NSDate*)time
{
    FRCreateEventTimeViewControllerNative* timeVC = [FRCreateEventTimeViewControllerNative new];
    timeVC.eventTime = time;
    timeVC.delegate = (id<FRCreateEventTimeViewControllerNativeDelegate>)self.presenter;
    [self.createEventController presentViewController:timeVC animated:NO completion:nil];
}

- (void)presentDateControllerWithDate:(NSDate*)date
{
    FRCreateEventDateViewControllerNative* dateVC = [FRCreateEventDateViewControllerNative new];
    dateVC.eventDate = date;
    dateVC.delegate = (id<FRCreateEventDateViewControllerNativeDelegate>)self.presenter;
    [self.createEventController presentViewController:dateVC animated:NO completion:nil];
}

- (void)presenLocationVC
{
    FRCreateEventLocationSelectViewController* locationVC = [FRCreateEventLocationSelectViewController new];
    locationVC.delegate = (id<FRCreateEventLocationDelegate>)self.presenter;
    [self.createEventController presentViewController:locationVC animated:YES completion:nil];
}

- (void)presentPhotoPickerController
{
    self.photoPickerController = [[FRPhotoPickerController alloc] initWithViewController:self.createEventController];
    self.photoPickerController.quality = 0.9;
    self.photoPickerController.delegate = (id<FRPhotoPickerControllerDelegate>)self.presenter;
}

- (void)showFBInviteDialog {
    [FRCreateEventInviteFriendsViewController openInviteDialogFromVC:self.createEventController delegate:nil];
}

- (void)showVerifyAlert:(NSString*)alert
{
    UIAlertController *alertVC = [UIAlertController
                                alertControllerWithTitle:@"Oops"
                                message:alert
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction: [UIAlertAction actionWithTitle:FRLocalizedString(@"common.ok", nil)
                                               style:UIAlertActionStyleDefault
                                             handler:nil ]];
    [self.createEventController presentViewController:alertVC animated:YES completion:nil];
}

@end
