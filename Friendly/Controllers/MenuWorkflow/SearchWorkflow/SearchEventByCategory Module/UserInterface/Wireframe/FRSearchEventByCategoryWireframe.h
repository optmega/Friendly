//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventModel;

@interface FRSearchEventByCategoryWireframe : NSObject

- (void)presentSearchEventByCategoryControllerFromNavigationController:(UINavigationController*)nc category:(NSString*)category;
- (void)dismissSearchEventByCategoryController;

- (void)presentSearchDiscoverPeopleControllerWithTag:(NSString*)tag;
- (void)presentPreviewEvent:(FREventModel*)event;
- (void)showUserProfileController:(NSString*)userId;
- (void)presentFilterController;
- (void)showShareController:(FREventModel*)event;
- (void)presentJoinController:(NSString*)eventId event:(FREventModel*)event;
- (void)showEventPreviewWithEvent:(FREvent *)event fromFrame:(CGRect)fram;
- (void)presentUserProfile:(UserEntity*)user;
@end
