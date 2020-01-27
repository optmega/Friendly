//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventModel, FRCreateEventVC;

@interface FRCreateEventWireframe : NSObject


@property (nonatomic, weak) FRCreateEventVC* createEventController;

- (void)presentCreateEventControllerFromNavigationController:(UIViewController*)nc event:(FREventModel*)eventModel animation:(BOOL)animation;
- (void)dismissCreateEventController;
- (void)dismissCreateEventControllerAndDelete;
- (void)presentSelectEventImageVC;
- (void)presentInviteCoHostVCWith:(NSString*)eventId;
- (void)presentInviteFriendsVCWith:(NSString *)eventId;
- (void)presentCategoryVC;
- (void)presentAgesControllerWithAgesMin:(NSValue*)min max:(NSValue*)max;
- (void)presentGenderControllerWithGender:(FRGenderType)gender;
- (void)presentOpenSlotsControllerWithSlots:(NSInteger)slots;
- (void)presentTimeControllerWithTime:(NSDate*)time;
- (void)presentDateControllerWithDate:(NSDate*)date;
- (void)showVerifyAlert:(NSString*)alert;
- (void)presenLocationVC;
- (void)presentPhotoPickerController;
- (void)showFBInviteDialog;

@end
