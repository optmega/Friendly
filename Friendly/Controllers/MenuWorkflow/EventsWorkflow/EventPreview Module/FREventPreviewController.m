//
//  FREventPreviewController.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewController.h"
#import "FREventPreviewConstants.h"
#import "FRStyleKit.h"
#import "FREventPreviewEventViewCell.h"
#import "FREventPreviewTextCell.h"
#import "FREventPreviewTitleInfoCell.h"
#import "FREventPreviewInfoCell.h"
#import "FREventPreviewAttendingCell.h"
#import "FREventPreviewCategoryCell.h"
#import "FRJoinEventViewController.h"
#import "FRMyEventsCellToolbar.h"
#import "FRMyEventsGuestViewController.h"
#import "FRMyEventsMoreViewController.h"
#import "FREventModel.h"
#import "FREventTransport.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FRAnimator.h"
#import "FRUserModel.h"
#import "FRUserManager.h"
#import "FRRequestTransport.h"
#import "FRCreateEventWireframe.h"
#import "FRTransitionAnimator.h"
#import "FRShareEventViewController.h"
#import "FRUserProfileWireframe.h"
#import "FRSearchEventByCategoryWireframe.h"
#import "FRMyProfileWireframe.h"
#import "BSHudHelper.h"
#import "FRSettingsTransport.h"
#import "FRPrivateChatWireframe.h"
#import "FRHomeVC.h"
#import "FRMyEventsViewController.h"

typedef NS_ENUM(NSUInteger, DissmissAnimationState)
{
    DissmissAnimationStateNone,
    DissmissAnimationStateBeforeScaling,
    DissmissAnimationStateScaling,
    DissmissAnimationStateAfterScaling
};

@interface FREventPreviewController () <UITableViewDataSource, UITableViewDelegate,FREventPreviewEventViewCellViewModelDelegate, FRMyEventsCellToolbarDelegate, FRMyEventsMoreViewControllerDelegate, FREventPreviewEventViewCellDelegate, FRJoinEventViewControllerDelegate, FREventPreviewAttendingCellDelegate, FREventPreviewInfoCellDelegate, FRMyEventsGuestViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITableView* eventPreviewTableView;
@property (strong, nonatomic) UIButton* joinButton;
@property (strong, nonatomic) UIButton* arrowButton;
@property (strong, nonatomic) UIButton* closeButton;
@property (strong, nonatomic) FRMyEventsCellToolbar* hostingToolbar;
@property (strong, nonatomic) FREvent* model;
@property (strong, nonatomic) FRSearchEventByCategoryWireframe* categoryWireframe;
@property (strong, nonatomic) FREventPreviewInfoCellViewModel* previewInfoModelWhere;
@property (strong, nonatomic) FREventPreviewInfoCellViewModel* previewInfoModelTime;
@property (strong, nonatomic) UIImageView* downCurves;
@property (strong, nonatomic) FREventPreviewInfoCellViewModel* previewInfoModelHostsNumber;
@property (strong, nonatomic) FREventPreviewInfoCellViewModel* previewInfoModelOpen;
@property (strong, nonatomic) FREventPreviewTextCellViewModel* previewTextModel;
@property (strong, nonatomic) FREventPreviewCategoryCellViewModel* previewCategoryModel;
@property (strong, nonatomic) FREventPreviewEventViewCellViewModel* previewEventViewModel;
@property (strong, nonatomic) FREventPreviewAttendingViewModel* previewAttendingModel;
@property (nonatomic, strong) UIImageView* cellImage;
@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, copy) NSString *countNearbyEvents;
@property (nonatomic, strong) UIButton* editButton;
@property (nonatomic, strong) MASConstraint* bottom;
@property (nonatomic, strong) MASConstraint* left;
@property (nonatomic, strong) MASConstraint* right;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIImageView* topCornerImage;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (assign, nonatomic) BOOL canSetOffset;
@property (nonatomic, assign) DissmissAnimationState dissmissAnimationState;
@property (assign, nonatomic) CGPoint mapContentOffset;
@property (nonatomic, strong) UIPanGestureRecognizer* panRecognizer;
@property (nonatomic, assign) CGRect tableFrame;


@property (nonatomic, assign) CGFloat lastPositionY;

@property (nonatomic, weak) UIViewController* tempvc;
@property (nonatomic, assign) CGRect frameForDismiss;

@end

@implementation FREventPreviewController

- (instancetype)initWithEvent:(FREvent*)event fromFrame:(CGRect)frame
{
    self = [self init];
    if (self)
    {
        self.model = event;
        event = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
        self.frameForDismiss = frame;
    
        self.eventId = event.eventId;
//        self.model = event;
        self.statusBarBackgraundView.hidden = YES;
        
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillDisappear:animated];
    [self.presentingViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.complite) {
        self.complite();
    }
    [self.tempvc setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableFrame = self.eventPreviewTableView.frame;
    self.eventPreviewTableView.bounces = false;
    self.eventPreviewTableView.backgroundColor = [UIColor clearColor];
    self.eventPreviewTableView.clipsToBounds = true;
    self.view.backgroundColor = [UIColor blackColor];
        self.tempvc = self.presentingViewController;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.closeButton];
    [self closeButton];
    [self arrowButton];
    [self separator];
    [self getData];
    [self changingEventType];
    [FRAnimator animateConstraint:self.left newOffset:15 key:@"left"];
    [FRAnimator animateConstraint:self.right newOffset:-15 key:@"right"];
    self.model = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.model.objectID];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEvent) name:UPDATE_EVENT object:nil];
    
    if (CGRectEqualToRect(self.frameForDismiss, CGRectZero)) {
        
        self.frameForDismiss = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    }
    
    [self downCurves];
    self.overleyNavBar.hidden = self.isHideOverley;
    [self.view addSubview:self.overleyNavBar];
    [self eventPreviewTableView];
    self.eventPreviewTableView.hidden = YES;
    self.dissmissAnimationState = DissmissAnimationStateBeforeScaling;
    [self getData];
    [self topCornerImage];
    
    __block FREventPreviewController *selfId = self;
    [FREventTransport getEventInfoWithId:selfId.eventId success:^(FREvent *event) {
        
        event = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
        selfId.model = event;
        [self getData];
        [FREventTransport searchEventsByTitle:event.category success:^(FREventSearchEntityModels *models) {
            selfId.countNearbyEvents = models.related_category.count;
        } failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
    
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.eventPreviewTableView.showsVerticalScrollIndicator = false;
    self.expandedIndexPath = nil;
    self.canSetOffset = YES;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.panRecognizer setMinimumNumberOfTouches:1];
    [self.panRecognizer setMaximumNumberOfTouches:1];

    
//    [self.eventPreviewTableView addGestureRecognizer:self.panRecognizer];
    
    self.panRecognizer.enabled = true;
    self.lastPositionY = 0;
    
    self.panRecognizer.delegate = self;
    FREventPreviewEventViewCell* cell = [self.eventPreviewTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.headerView addGestureRecognizer:self.panRecognizer];
    
    BSDispatchBlockAfter(1, ^{
        
        setStatusBarColor([UIColor whiteColor]);
    });
}

- (void)updateEvent
{
    [FREventTransport getEventInfoWithId:self.eventId success:^(FREvent *event) {
        event = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
        self.model = event;
        [self getData];
        [FREventTransport searchEventsByTitle:event.category success:^(FREventSearchEntityModels *models) {
            self.countNearbyEvents = models.related_category.count;
        } failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
}

-(void)move:(id)sender {
    
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    FREventPreviewEventViewCell* cell = [self.eventPreviewTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self changeAlpha:0];
        }];
    } else
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        CGFloat alpha = 60 / translatedPoint.y > 0.8 ? 0.8 : 60 / translatedPoint.y;
        
        
        
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: alpha > 0.5 ? alpha : 0.5];
            
        CGRect frame = cell.headerView.frame;
        frame.origin = translatedPoint;
        cell.headerView.frame = frame;

        
        
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateCancelled ||
        [(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        
        if (translatedPoint.y < 60) {
            
            
            CGRect frame = cell.headerView.frame;
            frame.origin = cell.frame.origin;
            
            [UIView animateWithDuration:0.3 animations:^{
                [self changeAlpha:1];
                cell.headerView.frame = frame;
            }];
        } else {
            
            [cell hideAllSubviews];
            
            if (self.frameForDismiss.size.height >= 350) {
                
                cell.overlayImage.hidden = true;
//                cell.headerView.contentMode = UIViewContentModeScaleToFill;
                
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                cell.headerView.frame = self.frameForDismiss;
                
            } completion:^(BOOL finished) {
            
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.alpha = 0;
                } completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:false completion:nil];
                }];
            }];
            
        }
    }
}

- (void)changeAlpha:(CGFloat)alpha {
   NSArray* cells = [self.eventPreviewTableView visibleCells];

    self.hostingToolbar.alpha = alpha < 1 ? .8 : 1;

    for (UITableViewCell* cell in cells) {
        if ([cell isKindOfClass:[FREventPreviewEventViewCell class]]) {
            FREventPreviewEventViewCell* headerCell = (FREventPreviewEventViewCell*)cell;
            
            headerCell.downView.alpha = alpha < 1 ? 0 : 1;
            headerCell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
            headerCell.joinButton.alpha = alpha;
            continue;
        }
        cell.alpha = alpha;
    }
}

#pragma mark UIGestureRecognizerDelegate

- (void)getData
{
         self.previewInfoModelWhere = [FREventPreviewInfoCellViewModel initWithModel:self.model type:(FRInfoCellViewModelTypeWhere)];
         self.previewInfoModelTime= [FREventPreviewInfoCellViewModel initWithModel:self.model type:(FRInfoCellViewModelTypeTime)];
         self.previewInfoModelHostsNumber = [FREventPreviewInfoCellViewModel initWithModel:self.model type:(FRInfoCellViewModelTypeHostsNumber)];
         self.previewInfoModelOpen = [FREventPreviewInfoCellViewModel initWithModel:self.model type:(FRInfoCellViewModelTypeOpen)];
         self.previewCategoryModel = [FREventPreviewCategoryCellViewModel initWithModel:self.model];
         self.previewEventViewModel = [FREventPreviewEventViewCellViewModel initWithModel:self.model];
         self.previewEventViewModel.delegate = self;
         self.previewTextModel = [FREventPreviewTextCellViewModel initWithModel:self.model];
         self.previewAttendingModel = [FREventPreviewAttendingViewModel initWithModel:self.model];
         if (self.model.requestStatus.integerValue == 2)
         {
             self.isAttendingStatus = YES;
         }
         if (([self.model.creator.user_id isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].currentUser.user_id]])||(([self.model.partnerHosting isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].currentUser.user_id]]&&([self.model.partnerIsAccepted isEqual:@1]))))
         {
             self.isHostingEvent = YES;
         }
         [self.eventPreviewTableView reloadData];
         self.eventPreviewTableView.hidden = NO;
         [UIView animateWithDuration:0.3 animations:^
         {
             self.cellImage.alpha = 0;
         } completion:^(BOOL finished) {
             [self changingEventType];
             [UIView animateWithDuration:0.3 animations:^
             {
                 if ((self.isAttendingStatus)||(self.isHostingEvent))
                 {
                     [FRAnimator animateConstraint:self.bottom newOffset:0 key:@"bottom"];
                         [self.eventPreviewTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.bottom.equalTo(self.view).offset(-50);
                         }];
                 }
             }
             completion:^(BOOL finished)
              {
                  
              }];
         }];
}

- (void)showActionSheet:(NSString*)userId
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:FRLocalizedString(@"Option", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* viewProfile = [UIAlertAction actionWithTitle:FRLocalizedString(@"View profile", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showUserProfile:userId];
    }];
    UIAlertAction* removeUser = [UIAlertAction actionWithTitle:FRLocalizedString(@"Remove user", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeUserAlert:userId];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:FRLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:viewProfile];
    [alert addAction:removeUser];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)removeUserAlert:(NSString*)userId
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning" message:FRLocalizedString(@"You won't be able to add this user again. Are you sure you don't want this person on your event?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* removeUser = [UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FRRequestTransport discardUserId:userId fromEventId:self.eventId success:^{
            [self.eventPreviewTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:NO];
        } failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:removeUser];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)attendingUserTaped:(NSString*)userId
{
    if ((self.isHostingEvent)&&(![userId isEqualToString:self.model.partnerHosting])&&(![userId isEqualToString:self.model.creator_id]))
    {
        [self showActionSheet:userId];
    }
    else
    {
        [self showUserProfile:userId];
    }
}

- (void) showUserProfile:(NSString *)userId
{
    self.eventPreviewTableView.contentOffset = CGPointZero;
    if ([[FRUserManager sharedInstance].currentUser.user_id isEqualToString:userId])
    {
        FRMyProfileWireframe* myWF = [[FRMyProfileWireframe alloc] init];
        [myWF presentMyProfileWithAnimationFrom:self];
    }
    else
    {
        FRUserProfileWireframe* profileWF = [[FRUserProfileWireframe alloc] init];
        UserEntity* e = [FRSettingsTransport getUserWithId:userId success:^(UserEntity* userProfile, NSArray *mutualFriends) {
            
            UserEntity* e = [FRSettingsTransport getUserWithId:userId success:nil failure:nil];
            
            [profileWF presentUserProfileFromViewController:self user:e fromLoginFlow:NO];
        } failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }];
        if (e){
            [profileWF presentUserProfileFromViewController:self user:e fromLoginFlow:NO];
        }
    }
}

- (void) showUserProfile
{
    self.eventPreviewTableView.frame = self.tableFrame;

    
    self.eventPreviewTableView.contentOffset = CGPointZero;
    if ((self.isHostingEvent)&&([[FRUserManager sharedInstance].currentUser.user_id isEqualToString:self.model.creator_id]))
    {
        FRMyProfileWireframe* myWF = [[FRMyProfileWireframe alloc] init];
        [myWF presentMyProfileWithAnimationFrom:self];
    }
    else
    {
        FRUserProfileWireframe* profileWF = [[FRUserProfileWireframe alloc] init];
     
        [profileWF presentUserProfileFromViewController:self user:self.model.creator fromLoginFlow:NO];
    }
}

- (void)showChatForEvent:(FREvent *)event {
    [[FRPrivateChatWireframe new] presentPrivateChatControllerFromNavigation:self.navigationController forEvent:event];
}

- (void) showPartnerProfile
{
    self.eventPreviewTableView.contentOffset = CGPointZero;
    if ([[FRUserManager sharedInstance].currentUser.user_id isEqualToString:self.model.partnerHosting])
    {
        FRMyProfileWireframe* myWF = [[FRMyProfileWireframe alloc] init];
        [myWF presentMyProfileWithAnimationFrom:self];
    }
    else
    {
    FRUserProfileWireframe* profilePartnerWF = [[FRUserProfileWireframe alloc] init];
    UserEntity* user = [FRSettingsTransport getUserWithId:self.model.partnerHosting success:^(UserEntity* userProfile, NSArray *mutualFriends) {
        UserEntity* e = [FRSettingsTransport getUserWithId:self.model.partnerHosting success:nil failure:nil];
        [profilePartnerWF presentUserProfileFromViewController:self user:e fromLoginFlow:NO];
    } failure:^(NSError *error) {
        //
    }];
    if (user)
    {

        [profilePartnerWF presentUserProfileFromViewController:self user:user fromLoginFlow:NO];
    }
    }

    //TODO: userEntity
//        [profilePartnerWF presentUserProfileControllerFromNavigationController:self.navigationController userId:self.model.partner_hosting];
}

- (void) changingEventType
{
  if (self.isHostingEvent)
    {
        [self.hostingToolbar updateWithType:FRMyEventsCellTypeHosting];
        self.hostingToolbar.cellToolBarDelegate = self;
        self.isAttendingStatus = YES;
        [self.hostingToolbar updateWithEvent:self.model andUsers:self.model.memberUsers.allObjects];
        [self.arrowButton setImage:[FRStyleKit imageOfEditCanvas] forState:UIControlStateNormal];
    }
    else if (self.isAttendingStatus)
    {
        [self.hostingToolbar updateWithType:FRMyEventsCellTypeJoining];
        self.hostingToolbar.cellToolBarDelegate = self;
        [self.hostingToolbar updateWithEvent:self.model andUsers:self.model.memberUsers.allObjects];
    }
    else
    {

    }
}

-(void) updateRequestStatus
{
    self.model.requestStatus = @1;
    [self getData];
    [self.eventPreviewTableView reloadData];
}

- (void) updateData
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showJoinRequest
{
     FRJoinEventViewController* joinVC = [FRJoinEventViewController new];
     joinVC.heightFooter = 255;
     joinVC.delegate = self;
     [joinVC updateWithEvent:self.model];
     [self presentViewController:joinVC animated:YES completion:nil];
}

- (void) guestsSelectWithUser:(NSMutableArray*)users andEvent:(FREvent *)event
{
    FRMyEventsGuestViewController* guestsVC = [FRMyEventsGuestViewController new];
    guestsVC.heightFooter = 310;
    guestsVC.users = users;
    guestsVC.eventId = event.eventId;
    guestsVC.event = event;
    guestsVC.delegate = self;
    if (self.isHostingEvent)
    {
        [guestsVC updateWithHostingType];
    }
    UINavigationController* unv = [[UINavigationController alloc] initWithRootViewController:guestsVC];
    unv.navigationBarHidden = YES;
    unv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    unv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:unv animated:YES completion:nil];
}

- (void) editEvent:(FREventModel *)event
{
    [[FRCreateEventWireframe new] presentCreateEventControllerFromNavigationController:self event:self.model animation:NO];
}

- (void) shareEvent:(FREventModel *)event
{
    FRShareEventViewController* shareVC = [FRShareEventViewController new];
    [shareVC updateWithEvent:self.model];
    [self presentViewController:shareVC animated:YES completion:^{
    }];
}

- (void) moreSelectWithEvent:(NSString*)eventId andModel:(FREventModel*)model
{
    FRMyEventsMoreViewController* moreVC = [FRMyEventsMoreViewController new];
    [moreVC updateWithEventId:eventId andModel:self.model];
    moreVC.delegate = self;
    moreVC.heightFooter = 240;
    [self presentViewController:moreVC animated:YES completion:nil];
}

- (void) showInviteWithEvent:(NSString*)eventId andEvent:(FREvent*)model
{
    FRCreateEventInviteFriendsViewController* inviteVC = [FRCreateEventInviteFriendsViewController new];
    inviteVC.heightFooter = 240;
    [inviteVC updateWithEventId:eventId andEvent:model];
    inviteVC.isVCForCreating = NO;
    [self presentViewController:inviteVC animated:YES completion:nil];
}

- (void) leaveEvent:(NSString *)eventId
{
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Warning"
                                                         message:@"Are you sure you want to leave this event?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                               otherButtonTitles:@"Yes", nil];
    [alert show];
}
    
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [FRRequestTransport unsubscribeWithEventId:self.eventId success:^{
            [self updateData];
        } failure:^(NSError *error) {
                //
        }];
    }
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.row == 8) {
        self.categoryWireframe = [[FRSearchEventByCategoryWireframe alloc] init];
          
          [self.categoryWireframe presentSearchEventByCategoryControllerFromNavigationController:self.navigationController category:self.model.category];
          
      }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    static NSString *CellIdentifier;
    
    if (indexPath.row == 0)
    {
        CellIdentifier = @"EventView";
        FREventPreviewEventViewCell *eventViewCell = (FREventPreviewEventViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!eventViewCell)
        {
            eventViewCell = [[FREventPreviewEventViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (self.isHostingEvent)
        {
            eventViewCell.joinButton.hidden = YES;
        }
        eventViewCell.clipsToBounds = YES;
        [eventViewCell updateWithModel:self.previewEventViewModel];
        eventViewCell.delegate = self;
        
        returnCell = eventViewCell;
    }
    else if (indexPath.row == 1)
    {
        CellIdentifier = @"Text";
        FREventPreviewTextCell *textCell =  (FREventPreviewTextCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!textCell)
        {
            textCell = [[FREventPreviewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        textCell.layer.zPosition = 2;
        [textCell updateWithModel:self.previewTextModel];
        returnCell = textCell;
    }
    else if (indexPath.row == 2)
    {
        CellIdentifier = @"EventInfoTitle";
        FREventPreviewTitleInfoCell *titleInfoCell =  (FREventPreviewTitleInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!titleInfoCell)
        {
            titleInfoCell = [[FREventPreviewTitleInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (self.isAttendingStatus)
        {
            [titleInfoCell updateTitleInfoCellWithAttendingStatus];
        }
        returnCell = titleInfoCell;
        
    }
    else if (indexPath.row == 3)
    {
        CellIdentifier = @"EventInfo";
        FREventPreviewInfoCell *infoCell =  (FREventPreviewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!infoCell)
        {
            infoCell = [[FREventPreviewInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        infoCell.separator.hidden = NO;
        infoCell.delegate = self;
        [infoCell updateWithModel:self.previewInfoModelWhere];
        if (self.isAttendingStatus)
        {
            [infoCell updateWhereInfoCellWithAttendingStatus:self.model.address lat:self.model.lat.stringValue lon:self.model.lon.stringValue];
        }
        returnCell = infoCell;
    }
    else if (indexPath.row == 4)
    {
        CellIdentifier = @"EventInfo";
        FREventPreviewInfoCell *infoCell =  (FREventPreviewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!infoCell)
        {
            infoCell = [[FREventPreviewInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [infoCell updateWithModel:self.previewInfoModelTime];
        if (self.isAttendingStatus)
        {
            [infoCell updateTimeInfoCellWithAttendingStatus:self.model.event_start];
        }
        infoCell.separator.hidden = NO;

        returnCell = infoCell;
        
    }
    else if (indexPath.row == 5)
    {
        CellIdentifier = @"EventInfo";
        FREventPreviewInfoCell *infoCell =  (FREventPreviewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!infoCell)
        {
            infoCell = [[FREventPreviewInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        infoCell.separator.hidden = NO;

        [infoCell updateWithModel:self.previewInfoModelHostsNumber];

        returnCell = infoCell;
    }
    else if (indexPath.row == 6)
    {
        CellIdentifier = @"EventInfo";
        FREventPreviewInfoCell *infoCell =  (FREventPreviewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!infoCell)
        {
            infoCell = [[FREventPreviewInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

            infoCell.separator.hidden = YES;

        [infoCell updateWithModel:self.previewInfoModelOpen];

        returnCell = infoCell;
    }
    
    else if (indexPath.row == 7)
    {
        CellIdentifier = @"Attending";
        FREventPreviewAttendingCell *attendingCell =  (FREventPreviewAttendingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!attendingCell)
        {
            attendingCell = [[FREventPreviewAttendingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        [attendingCell updateWithModel:self.previewAttendingModel];
        attendingCell.delegate = self;
        returnCell = attendingCell;
    }
    else if (indexPath.row == 8)
    {
        CellIdentifier = @"Category";
        FREventPreviewCategoryCell *categoryCell = (FREventPreviewCategoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!categoryCell)
        {
            categoryCell = [[FREventPreviewCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [categoryCell updateWithModel:self.previewCategoryModel countNearbyEvents:self.countNearbyEvents];
        returnCell = categoryCell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        returnCell.layer.zPosition = 3;
        returnCell.clipsToBounds = false;
    } else {
        returnCell.layer.zPosition = 2;
    }
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case FREventPreviewEventView:
        {
            return 355;
        } break;
        case FREventPreviewText:
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
            label.numberOfLines = 0;
            label.text = self.previewTextModel.infoText;
            [label sizeToFit];
            return label.bounds.size.height + 70;

        } break;
        case FREventPreviewTitleInfo:
        {
            return 80;
        } break;
        case FREventPreviewInfoWhere:
        {
            if (self.isAttendingStatus)
            {
                if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
                    return self.view.bounds.size.height-50; // Expanded height
                }
                else{
            return 255;
                }
            }
            else
            {
            return 57.5;
            }
            
        } break;
        case FREventPreviewInfoMeetTime:
        {
            return 57.5;
            
        } break;
        case FREventPreviewInfoHostsNumber:
        {
            if ([self.model.creator.mobileNumber isEqualToString:@""])
            {
                return 0;
            }
            else
            {
            return 57.5;
            }
            
        } break;
        case FREventPreviewInfoOpenToFriends:
        {
            return 57.5;
            
        } break;
        case FREventPreviewAttending:
        {
            return 238;
        } break;
        case FREventPreviewCategory:
        {
            return 125;
            
        } break;
        case FREventPreviewJoinEvent:
        {
            return 50;
            
        } break;
        default:
            return self.eventPreviewTableView.rowHeight;
            break;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat verticalShift = scrollView.contentOffset.y;
    
    [self changePositionY:scrollView.contentOffset.y];
    
    if (verticalShift >= -1) {
        FREventPreviewInfoCell* mapCell = (FREventPreviewInfoCell*)[self.eventPreviewTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        if ((self.isAttendingStatus)&&(self.canSetOffset))
        {
            [mapCell updateMapWithOffset:self.eventPreviewTableView.contentOffset.y];
        }
    } else {
//        [self changePositionY:scrollView.contentOffset.y];
    }
}


#pragma mark - LazyLoad

-(UITableView*) eventPreviewTableView
{
    if (!_eventPreviewTableView)
    {
        _eventPreviewTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _eventPreviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _eventPreviewTableView.allowsSelection = YES;
        _eventPreviewTableView.clipsToBounds = YES;
        _eventPreviewTableView.layer.masksToBounds = YES;
        _eventPreviewTableView.delegate = self;
        _eventPreviewTableView.dataSource = self;
        [self.view addSubview:_eventPreviewTableView];
        [_eventPreviewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _eventPreviewTableView;
}

-(UIButton*) joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
        [_joinButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [_joinButton setTitle:@"Join event" forState:UIControlStateNormal];
        _joinButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_joinButton];
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
            self.bottom =  make.bottom.equalTo(self.view).offset(50);
        }];
    }
    return _joinButton;
}

-(FRMyEventsCellToolbar*) hostingToolbar
{
    if (!_hostingToolbar)
    {
        _hostingToolbar = [FRMyEventsCellToolbar new];
        [self.view addSubview:_hostingToolbar];
        [_hostingToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
            self.bottom =  make.bottom.equalTo(self.view).offset(50);
        }];
    }
    return _hostingToolbar;
}

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:@"E8EBF1"]];
        [self.view addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.top.equalTo(self.hostingToolbar);
            make.height.equalTo(@1);
        }];
        
    }
    return _separator;
}

-(UIButton*) arrowButton
{
    if (!_arrowButton)
    {
        _arrowButton = [UIButton new];
        [_arrowButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        _arrowButton.layer.masksToBounds = NO;
        _arrowButton.layer.zPosition = 5;
        [_arrowButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(showShareVC:) forControlEvents:UIControlEventTouchUpInside];
        _arrowButton.layer.cornerRadius = 17.5;
        [self.view addSubview:_arrowButton];
        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30);
            self.right =  make.right.equalTo(self.view).offset(35);
            make.width.height.equalTo(@35);
        }];
    }
    return _arrowButton;
}

-(UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        _closeButton.layer.zPosition = 5;
        [_closeButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        [_closeButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        _closeButton.layer.cornerRadius = 17.5;
        [_closeButton addTarget:self action:@selector(selectedClose) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.layer.masksToBounds = NO;
        [self.view addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30);
            make.width.height.equalTo(@35);
            self.left =  make.left.equalTo(self.view).offset(-35);
        }];
    }
    return _closeButton;
}

-(UIImageView*)topCornerImage
{
        if (!_topCornerImage)
        {
            _topCornerImage = [UIImageView new];
            [_topCornerImage setImage:[FRStyleKit imageOfGroup4Canvas2]];
            _topCornerImage.layer.zPosition = 10;
            _topCornerImage.contentMode = UIViewContentModeScaleToFill;
            [self.view addSubview:_topCornerImage];
            [_topCornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.view);
                make.height.equalTo(@14);
            }];
        }
        return _topCornerImage;
}

-(UIImageView*)downCurves
{
    if (!_downCurves)
    {
        _downCurves = [UIImageView new];
        [_downCurves setImage:[FRStyleKit imageOfGroup4CopyCanvas]];
        _downCurves.contentMode = UIViewContentModeScaleToFill;
        _downCurves.layer.zPosition = 10;
        [self.view addSubview:_downCurves];
        [_downCurves mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@14);
        }];
    }
    return _downCurves;
}


#pragma mark - FREventPreviewEventViewCellViewModelDelegate

- (void)selectedClose
{
    CGRect frame = self.eventPreviewTableView.frame;
    frame.origin.y = 750;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.overleyNavBar.backgroundColor = [UIColor clearColor];
        self.eventPreviewTableView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
    }];
    return;
    
//    if (self.isFromEvent) {
//        
//        [self dismissViewControllerAnimated:true completion:nil];
//    } else {
////        UIViewController* temp = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [[FRTransitionAnimator new] dismissViewController:self.presentingViewController from:self];
//    }
}

- (void)showShareVC:(UIButton*)sender
{
    if (self.isHostingEvent)
    {
        [self editEvent:self.model];
    }
    else
    {
        [self shareEvent:self.model];
    }
}

-(void)expandMap:(BOOL)isExpanding
{
    self.panRecognizer.enabled = isExpanding;
    [self.eventPreviewTableView beginUpdates];
    self.canSetOffset = NO;
    [self.view layoutIfNeeded];
    if (!isExpanding)
    {
        self.expandedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        self.eventPreviewTableView.scrollEnabled = NO;
        self.mapContentOffset = self.eventPreviewTableView.contentOffset;
        [FRAnimator animateConstraint:self.left newOffset:-35 key:@"left" delay:0.3 bouncingRate:0];
        [FRAnimator animateConstraint:self.right newOffset:80 key:@"right" delay:0.3 bouncingRate:0];
    }
    else
    {
        self.expandedIndexPath = nil;
        self.eventPreviewTableView.scrollEnabled = YES;
        [FRAnimator animateConstraint:self.left newOffset:15 key:@"left" delay:0.3 bouncingRate:0];
        [FRAnimator animateConstraint:self.right newOffset:-15 key:@"right" delay:0.3 bouncingRate:0];
    }
    [self.eventPreviewTableView endUpdates];
    if (!isExpanding) {
        [self.eventPreviewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.canSetOffset = YES;
            CGPoint scrollP =  self.eventPreviewTableView.contentOffset;
            scrollP.y = scrollP.y+1;
            [self.eventPreviewTableView setContentOffset:scrollP animated:YES];
        });
        [self.eventPreviewTableView setContentOffset:self.mapContentOffset animated:YES];
    }
}


#pragma mark - Privates

- (void)changePositionY:(CGFloat)y
{
    
    
    return;
    if (self.dissmissAnimationState != DissmissAnimationStateBeforeScaling) {
        return;
    }
    
    self.dissmissAnimationState = DissmissAnimationStateScaling;
    UIViewController* temp = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [[FRTransitionAnimator new] scaleViewController:temp from:self withBlock:^{
        CFTimeInterval interval = 0.7f;
        self.dissmissAnimationState = DissmissAnimationStateAfterScaling;
        
        NSValue* (^value)(CGPoint point) = ^NSValue*(CGPoint point){
            return [NSValue valueWithCGPoint:point];
        };
        
        CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        move.values = @[value(self.view.layer.position),
                        value(CGPointMake(self.view.layer.position.x, 400)),
                        value(self.view.layer.position)];
        move.duration = interval;
        move.fillMode = kCAFillModeBoth;
        
        
        CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        resizeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 0.6f)];
        resizeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)];
        [resizeAnimation setDuration:interval];
        resizeAnimation.fillMode = kCAFillModeBoth;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.fillMode = kCAFillModeBoth;
        group.removedOnCompletion = NO;
        [group setAnimations:@[move, resizeAnimation]];
        group.duration = interval;
        group.delegate = self;
        
        [self.view.layer addAnimation:group forKey:@"savingAnimation"];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return false;
}



@end

