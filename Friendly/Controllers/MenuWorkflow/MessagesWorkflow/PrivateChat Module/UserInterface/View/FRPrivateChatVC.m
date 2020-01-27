//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatVC.h"
#import "FRPrivateChatController.h"
#import "FRPrivateChatDataSource.h"
#import "FRPrivateChatContentIVew.h"

#import "FRUserManager.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"
#import "UIImageView+WebCache.h"

#import "FRGroupUsersHeaderView.h"
#import "JSQLocationMediaItem.h"
#import "FRGroupRoom.h"
#import "FRDateManager.h"
#import "FRAnimator.h"
#import "FRPrivateChatUserHeader.h"
#import "FRGroupChatNavigationView.h"
#import "FRGroupMessage.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>


//@import GoogleMobileAds;

@interface FRPrivateChatVC () <NSFetchedResultsControllerDelegate, FRGroupUsersHeaderViewModelDelegate, FRGroupUsersHeaderViewDelegate>

@property (nonatomic, strong) FRPrivateChatController* controller;
@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIRefreshControl* refreshController;



@property (nonatomic, strong) FRGroupUsersHeaderViewModel* headerViewModel;

@property (nonatomic, strong) FRPrivateChatUserHeaderViewModel* headerPrivateViewModel;
@property (nonatomic, strong) FRGroupRoom* groupRoom;

@property (nonatomic, strong) UIView* bannerContainer;
@property (nonatomic, strong) MASConstraint* heightConstr;
@property (nonatomic, strong) FRGroupChatNavigationView* navBar;
@property (nonatomic, strong) FRGroupUsersHeaderView* headerView;

@property (nonatomic, strong) JSQMessagesBubbleImage* outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage* incomingBubbleImageData;

@property (nonatomic, strong) UIButton* locationButton;
@property (nonatomic, strong) UIButton* sendButton;
@property (nonatomic, strong) NSFetchedResultsController* frc;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, assign) BOOL isLoadOldMessage;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, strong) NSMutableArray* sectionChanges;
@property (nonatomic, strong) NSMutableArray* itemChanges;



@end


@implementation FRPrivateChatVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        self.dataMessages = [FRChatMessageModelData new];
    }
    return self;
}


- (void)refreshTable:(id)sender
{
    self.isLoadOldMessage = true;
    self.lastCount = self.frc.fetchedObjects.count;
    [self.eventHandler loadOldMessageWithCount:self.frc.fetchedObjects.count];
}

- (void)oldMessageLoaded {
    [self.refreshControl endRefreshing];
}

- (void)setupWithRoomId:(NSString*)roomId {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"eventId == %@", roomId];
    self.frc = [FRGroupMessage MR_fetchAllSortedBy:@"createDate" ascending:true withPredicate:predicate groupBy:nil delegate:self];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FRGroupMessage"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:true]]];
    fetchRequest.predicate = predicate;
    [fetchRequest setFetchBatchSize:5];
    
    [[self.frc fetchRequest] setFetchBatchSize:5];
    NSError* error;
    [self.frc performFetch:&error];
    
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
//    [self.collectionView reloadData];
//    
//    return;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    
    @try {
    
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
//                    case NSFetchedResultsChangeDelete:
//                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
//                        break;
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert: {
                        
                        
//                        if (self.isLoadOldMessage) {
//                            
//                            CGFloat bottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y;
//                            
//                            [CATransaction begin];
//                            [CATransaction setDisableActions:YES];
//                            
//                            [self.collectionView performBatchUpdates:^{
//                                [self.collectionView insertItemsAtIndexPaths:@[obj]];
//                            } completion:^(BOOL finished) {
//                                self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - bottomOffset);
//                                [CATransaction commit];
//                            }];
//                            
//                            self.isLoadOldMessage = false;
//                        } else {
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
//                        }
                        
                        
                        
//                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
    
                        }
                        break;
//                    case NSFetchedResultsChangeDelete:
//                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
//                        break;
//                    case NSFetchedResultsChangeUpdate:
//                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
//                        break;
//                    case NSFetchedResultsChangeMove:
//                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
//                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
        
      
        [CATransaction commit];

        [CATransaction setDisableActions:false];
         [CATransaction commit];
        
        [UIView setAnimationsEnabled:true];
        if (!self.isLoadOldMessage) {
            
//            [UIView animateWithDuration:0.3 animations:^{
//                
//                self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height + 90);
//            }];
            
            
//            NSInteger section = [self.collectionView numberOfSections] - 1;
//            NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (!self.isLoadOldMessage) {
//                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
                
                [self scrollToBottomAnimated:true];
                
            } else {
                
            }
            
        }
    }];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;
    

    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"00B4FB"]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"EEF1F7"]];

    
    [self.inputToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.inputToolbar setShadowImage:[UIImageHelper imageFromColor:[UIColor bs_colorWithHexString:@"E4E6EA"]] forToolbarPosition:UIBarPositionAny];
    
    self.navBar.titleLabel.text = [NSString stringWithFormat:@"%@ ›", [self.eventForChat title]];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:self.navBar.titleLabel.text];
    
    
    [attribute addAttribute:NSForegroundColorAttributeName
                   value:[UIColor bs_colorWithHexString:@"#939BAF"]
                   range:NSMakeRange(self.navBar.titleLabel.text.length - 1, 1)];
    self.navBar.titleLabel.attributedText = attribute;
    self.navBar.subtitleLabel.text = [FRDateManager groupTime:[self.eventForChat event_start]];
    
    
    @weakify(self);
    
    [[self.navBar.centerItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self setNeedsStatusBarAppearanceUpdate];
        [self.eventHandler showEvent];
    }];
    
    [[self.navBar.leftItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    [[self.navBar.rightItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showActionSheet:self.navBar.rightItem];
    }];
    
    
    FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.eventForChat.objectID];
    
    self.navBar.separator.hidden = true;
    FRGroupUsersHeaderViewModel* headerModel = [FRGroupUsersHeaderViewModel new];
    headerModel.dateJoined = event.joinedAt;
    headerModel.cohost = event.partnerUser;
    headerModel.delegate = self;
    headerModel.users = [[event memberUsers] allObjects];
    MemberUser* creator = [MemberUser MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    creator.firstName = event.creator.firstName;
    creator.userId = event.creator.user_id;
    creator.photo = event.creator.userPhoto;
    headerModel.creator = creator;
    
    [self.headerView updateWithModel:headerModel];
    self.topCollectionViewConstr.constant = 175;
    
    
    self.heightForAd = 0;
    self.toolbarBottomLayoutGuide.constant = 0;
    
   
        
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor bs_colorWithHexString:kPurpleColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    self.senderId = [FRUserManager sharedInstance].userModel.id;
    self.senderDisplayName = @"senderDisplayName";
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    self.inputToolbar.maximumHeight = 110;
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.showLoadEarlierMessagesHeader = NO;
    

    
  
    UIButton* leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButton.layer.cornerRadius = 15;
    leftButton.backgroundColor = [UIColor whiteColor];
//    self.inputToolbar.contentView.leftBarButtonItem = self.leftButton;
    
     self.inputToolbar.contentView.leftBarButtonItem = nil;

    
    self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, 30, 30)];
    [self.sendButton setImage:[FRStyleKit imageOfSenddisabledCanvas] forState:UIControlStateDisabled];
    [self.sendButton setImage:[FRStyleKit imageOfSendMessageOnCanvas] forState:UIControlStateNormal];
    
    self.locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.locationButton setImage:[FRStyleKit imageOfSendlocationCanvas] forState:UIControlStateNormal];
    
    [self.locationButton addTarget:self action:@selector(shareLocation) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.inputToolbar.contentView.rightBarButtonItem = self.sendButton;
    [self.inputToolbar.contentView.rightBarButtonContainerView addSubview: self.locationButton];
    self.inputToolbar.contentView.rightBarButtonItemWidth = 70;
    
    
    
    self.inputToolbar.contentView.backgroundColor = [UIColor whiteColor];
    self.inputToolbar.contentView.textView.layer.borderColor = [UIColor clearColor].CGColor;
    /*
     *  Register custom menu actions for cells.
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action"
                                                                                      action:@selector(customAction:)] ];
     
      */
    
    /**
     *  OPT-IN: allow cells to be deleted
     
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
     
     */
    
    
    if ([FRUserManager sharedInstance].canShowAdvertisement)
    {
        [self showAdvertisement];
    }
    
    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].userModel.photo]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.leftButton setImage:image forState:UIControlStateNormal];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageStatus:) name:kUpdateMessageStatus object:nil];
    
    
    
    
    if ([FRUserManager sharedInstance].canShowAdvertisement)
    {
        [FRAnimator animateConstraint:self.heightConstr newOffset:50 key:@"(NSString*)key"];
        
        self.heightForAd = 50;
        self.toolbarBottomLayoutGuide.constant = 50;
    }

    
//    [FRAnimator animateConstraint:self.heightConstr newOffset:50 key:@"(NSString*)key"];
//    
//    self.heightForAd = 50;
//    self.toolbarBottomLayoutGuide.constant = 50;
    [self isActiveKeyboard:false];
    
    
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self isActiveKeyboard:true];
    return true;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self isActiveKeyboard:false];
    return true;
}


- (void)isActiveKeyboard:(BOOL)isActive {
    
    if (isActive) {
        self.locationButton.frame = CGRectMake(5, 2.5, 25, 25);
        self.sendButton.hidden = false;
    } else {
        self.locationButton.frame = CGRectMake(32.5, 2.5, 25, 25);
        self.sendButton.hidden = true;
        
    }
}


- (void)updateMessageStatus:(NSNotification*)model
{
    
//    NSDictionary* messageDict = model.object;
//    NSDictionary* data = messageDict[@"data"];
//    
//    JSQMessage* message = self.dataMessages.messages.lastObject;
//    NSNumber* mesId = data[@"msg_id"];
//    NSLog(@"%@", mesId);
//    if (message.messageId.integerValue == mesId.integerValue)
//    {
//        message.messageStatus = [data[@"msg_status"] integerValue];
//        BSDispatchBlockToMainQueue(^{
//            [self.collectionView reloadData];
//        });
//    }
}


- (void)updatePrivateHeader:(FRPrivateChatUserHeaderViewModel*)model
{
    self.headerPrivateViewModel = model;
}


- (void)showAdvertisement
{
    self.bannerContainer = [UIView new];
    self.bannerContainer.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.bannerContainer];
    
    [self.bannerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        self.heightConstr = make.height.equalTo(@0);
    }];
    
    FBAdView* adView = [[FBAdView alloc] initWithPlacementID:PLACEMENT_ID adSize:kFBAdSizeHeight50Banner rootViewController:self];
    
    [self.bannerContainer addSubview:adView];
    
    [adView loadAd];
}

- (void)selectedUser:(UserEntity*)user {
    
}

//
//- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
//{
//   
//    if (self.heightForAd == 0) {
//         bannerView.alpha = 0;
//        
////        [FRAnimator animateConstraint:self.heightConstr newOffset:50 key:@"(NSString*)key"];
////        
////        self.heightForAd = 50;
////        self.toolbarBottomLayoutGuide.constant = 50;
//        
//        BSDispatchBlockAfter(0.5, ^{
//            bannerView.alpha = 1;
//        });
//    }
//}


- (void)updateWithGroup:(FRGroupRoom*)groupRoom
{
    self.groupRoom = groupRoom;
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if (kind == UICollectionElementKindSectionHeader) {
//        
//        if (self.eventHandler.isGroupChat)
//        {
//            FRGroupUsersHeaderView* reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//            
//            if (reusableview==nil) {
//                
//                CGFloat height = self.headerViewModel.users.count ? 175 : 50;
//                reusableview = [[FRGroupUsersHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
//            }
//            
//            [reusableview updateWithModel:self.headerViewModel];
//            return reusableview;
//        } else {
//            
//            if (!self.dataMessages.messages.count && self.headerPrivateViewModel)
//            {
//                FRPrivateChatUserHeader* reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRPrivateChatUserHeader" forIndexPath:indexPath];
//                
//                if (reusableview==nil){
//                    reusableview = [[FRPrivateChatUserHeader alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 250)];
//                }
//                [reusableview updateWithModel:self.headerPrivateViewModel];
//                return reusableview;
//            }
//        }
//        
//    }
//    
//    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    
//    if ([self.eventHandler isGroupChat])
//    {
//        CGFloat height = self.headerViewModel.users.count ? 175 : 50;
//        CGSize headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, height);
//        return headerSize;
//    }
//    else if (!self.dataMessages.messages.count)
//    {
//        return CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 250);
//    }
//    
//    return CGSizeZero;
//}


- (void)showEvent
{
    [self.eventHandler showEventWithID:self.groupRoom.eventId];
}

- (UIButton*)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _leftButton.layer.cornerRadius = 15;
        _leftButton.clipsToBounds = YES;
        _leftButton.backgroundColor = [UIColor whiteColor];
    }
    return _leftButton;
}

- (void)updateGroupHeader:(FRGroupUsersHeaderViewModel*)model
{
    self.headerViewModel = model;
}

- (void)updateUserPhotos:(NSDictionary*)dict
{
//    self.dataMessages.avatars = dict;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIView setAnimationsEnabled:true];
}

- (void)viewWillAppear:(BOOL)animated
{
       
    if (self.senderId == nil) {
        
        self.senderId = [[FRUserManager sharedInstance].currentUser user_id];
    }
    
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
    [super viewWillAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    
    
    NSArray* allMessage = [FRGroupMessage MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@ OR messageStatus == %@", self.groupRoom.eventId, @(2)]
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    
    
    for (FRGroupMessage* message in allMessage) {
        message.messageStatus = @(3);
        [FRDataBaseManager readMessage:message];
    }

    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    
//    NSInteger section = [self.collectionView numberOfSections] - 1;
//    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//    
// if (item >= 0)
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
//        
 

}


- (void)updateMessages:(NSArray*)messages
{
//    [self.refreshController endRefreshing];
//    if(!messages.count)
//    {
//        return;
//    }
//    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
//                           NSMakeRange(0,[messages count])];
//    
//    [self.dataMessages.messages insertObjects:messages atIndexes:indexes];
////    self.dataMessages.messages = [NSMutableArray arrayWithArray:messages];
////    [self finishSendingMessageAnimated:NO];
//    
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count ? messages.count - 1 : 0 inSection:0];
//    
//    
//    [UIView setAnimationsEnabled:NO];
//    
//    [self.collectionView reloadData];
//    
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
//
//    [UIView setAnimationsEnabled:YES];
//    
//    BSDispatchBlockAfter(2, ^{
//        [self.collectionView reloadData];
//    });
    
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.eventHandler backSelected];
}

- (void)recivedMessage:(JSQMessage*)message
{
//    [self.dataMessages.messages addObject:message];
//    
//    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
//    [self finishReceivingMessageAnimated:YES];
//    
//    if (message.isMediaMessage)
//    {
//        BSDispatchBlockAfter(2, ^{
//            
//            [self.collectionView reloadData];
//        });
//    }
}

- (void)shareLocation
{
    [self.eventHandler shareLocation];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    BSDispatchBlockAfter(0.8, ^{
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void)showActionSheet:(UIButton *)sender
{

     [self.view endEditing:YES];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:FRLocalizedString(@"Option", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* eventDetails = [UIAlertAction actionWithTitle:@"Event details" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.eventHandler showEvent];
    }];
    
    UIAlertAction* shareLocation = [UIAlertAction actionWithTitle:FRLocalizedString(@"Share location", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.eventHandler shareLocation];
    }];
    
    UIAlertAction* leaveEvent = [UIAlertAction actionWithTitle:@"Leave event" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self leaveEvent];
    }];
    
    UIAlertAction* deleteEvent = [UIAlertAction actionWithTitle:@"Delete event" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteEvent];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:FRLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:eventDetails];
    [alert addAction:shareLocation];
    
    BOOL canDelete = [[[FRUserManager sharedInstance].currentUser hostingEvents] containsObject:self.eventForChat];
    if (canDelete) {
        [alert addAction:deleteEvent];
    } else {
        
        [alert addAction:leaveEvent];
    }
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)leaveEvent {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Warning", nil) message:FRLocalizedString(@"Are you sure you want to leave this event?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.eventHandler leaveEvent];
    }];
    
    UIAlertAction* decline = [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:decline];
    [alertController addAction:accept];
    [self.navigationController presentViewController:alertController animated:true completion:nil];

}

- (void)deleteEvent {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Warning", nil) message:FRLocalizedString(@"Are you sure you want to delete this event?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.eventHandler deleteEvent];
    }];
    
    UIAlertAction* decline = [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:decline];
    [alertController addAction:accept];
    [self.navigationController presentViewController:alertController animated:true completion:nil];
    
}


- (void)didPressAccessoryButton:(UIButton *)sender
{
//    if (!self.eventHandler.isGroupChat)
//    {
//        [self.eventHandler showUserProfile];
//
//    }
}

- (void)updateLastMessage:(JSQMessage*)message
{
//    JSQMessage* messageLast = [self.dataMessages.messages lastObject];
//    if ([message.text isEqualToString:messageLast.text])
//    {
//        [self.dataMessages.messages removeLastObject];
//        [self.dataMessages.messages addObject:message];
//    }
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                             senderDisplayName:senderDisplayName
//                                                          date:date
//                                                          text:text];
//    [self.dataMessages.messages addObject:message];
    [self.eventHandler sendMessage:text];
    
    [self finishSendingMessageAnimated:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    BSDispatchBlockAfter(0.8, ^{
       
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

#pragma mark - User Interface

- (void)updateDataSource:(FRPrivateChatDataSource *)dataSource event:(FREvent *)event
{
    self.eventForChat = event;
    [self.controller updateDataSource:dataSource];
}


#pragma mark - FRTableController Delegate



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id entity =  [self.frc objectAtIndexPath:indexPath];
    return [self.eventHandler createJSQMessage:entity];

}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.dataMessages.messages removeObjectAtIndex:indexPath.item];
    
    
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id entity =  [self.frc objectAtIndexPath:indexPath];
    
    return (id)((FRGroupMessage*)entity).userPhoto;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.item || [self showTimeForIndexPath:indexPath]) {
        
        id entity =  [self.frc objectAtIndexPath:indexPath];
        JSQMessage *message = [self.eventHandler createJSQMessage:entity];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (BOOL)showTimeForIndexPath:(NSIndexPath *)indexPath
{
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *msg = [self.eventHandler createJSQMessage:entity];
    
    id entityLast =  [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
    JSQMessage *msgLast = [self.eventHandler createJSQMessage:entityLast];
    NSTimeInterval timeInterval = [msg.date timeIntervalSinceDate:msgLast.date];
    if (timeInterval < 0)
    {
        timeInterval *= -1;
    }
    
    return timeInterval > 60;
}



- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![self.eventHandler isGroupChat] && indexPath.row == self.dataMessages.messages.count - 1){
//        
//        JSQMessage* message = [self.dataMessages.messages lastObject];
//        if ([message.senderId isEqualToString: self.senderId])
//        {
//            return 30.0f;
//        }
//    }
    
    return 0;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
        id entity =  [self.frc objectAtIndexPath:indexPath];
        JSQMessage *message = [self.eventHandler createJSQMessage:entity];
        
        if (message.messageStatus == FRMessageStatusDelivered) {
            [FRDataBaseManager readMessage:entity];
        }
    
    return nil;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.frc.fetchedObjects.count;//[self.dataMessages.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *msg = [self.eventHandler createJSQMessage:entity];
    
    if ([msg.senderId isEqualToString:self.senderId])
    {
        //        cell.textView.layer.borderColor = [UIColor bs_colorWithHexString:@"#00B4FB"].CGColor;
        //        cell.textView.layer.borderWidth = 1;
        //        cell.textView.layer.cornerRadius = 10;
        //        cell.textView.backgroundColor = [UIColor bs_colorWithHexString:@"#00B4FB"];
    }
    else
    {
        //        cell.textView.layer.borderColor = [UIColor bs_colorWithHexString:@"#BDC1CB"].CGColor;
        //        cell.textView.layer.borderWidth = 1;
        //        cell.textView.layer.cornerRadius = 4;
    }
    
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor bs_colorWithHexString:KTextTitleColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FRBaseMessage *entity = [self.frc objectAtIndexPath:indexPath];
    
    if ([entity.creatorId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
    
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *message = [self.eventHandler createJSQMessage:entity];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        
        id entity =  [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        JSQMessage *previousMessage = [self.eventHandler createJSQMessage:entity];
        
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }

    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}




#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}




- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
//    if (indexPath.item % 3 == 0) {
    if (!indexPath.item || [self showTimeForIndexPath:indexPath]){
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *currentMessage = [self.eventHandler createJSQMessage:entity];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        
        
        id entity =  [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        JSQMessage *previousMessage = [self.eventHandler createJSQMessage:entity];
        
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}



//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.0f;
//}


#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
    
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *message = [self.eventHandler createJSQMessage:entity];
    
    if ([message.media isKindOfClass:[JSQLocationMediaItem class]])
    {
        JSQLocationMediaItem* item = (JSQLocationMediaItem*)message.media;
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com.ua/maps?q=loc:%f,%f", item.location.coordinate.latitude, item.location.coordinate.longitude]]];
        
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (FRGroupChatNavigationView*)navBar
{
    if (!_navBar)
    {
        _navBar = [[[UINib nibWithNibName:@"FRGroupChatNavigationView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        _navBar.frame = frame;
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (FRGroupUsersHeaderView*)headerView
{
    if (!_headerView)
    {
        _headerView = [FRGroupUsersHeaderView new];
        _headerView.delegate = self;
        CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 105);
        _headerView.frame = frame;
        [self.view addSubview:_headerView];
      
    }
    return _headerView;
}

- (void)selectedUserId:(NSString*)userId {
    [self.eventHandler showUserProfileWithId:userId];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.willShowEventPreview) {
        setStatusBarColor([FRUserManager sharedInstance].statusBarStyle == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor]);
        return [FRUserManager sharedInstance].statusBarStyle;
    }
    
    setStatusBarColor([UIColor blackColor]);
    return  UIStatusBarStyleDefault;
}

@end
