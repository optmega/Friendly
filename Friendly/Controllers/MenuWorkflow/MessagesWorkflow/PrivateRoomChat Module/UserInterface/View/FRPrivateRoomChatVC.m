//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatVC.h"
#import "FRPrivateRoomChatController.h"
#import "FRPrivateRoomChatDataSource.h"


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
#import "FRPrivateMessage.h"

#import <FBAudienceNetwork/FBAudienceNetwork.h>

#import "UIImageHelper.h"

#import "FRPrivateRoomHeaderView.h"
#import "FRWebSocketConstants.h"
#import "FRBaseVC.h"

@interface FRPrivateRoomChatVC () <UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) FRPrivateChatController* controller;
@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) UIView* titleGroupView;


@property (nonatomic, strong) FRGroupUsersHeaderViewModel* headerViewModel;

@property (nonatomic, strong) FRPrivateChatUserHeaderViewModel* headerPrivateViewModel;
@property (nonatomic, strong) FRGroupRoom* groupRoom;

@property (nonatomic, strong) UIView* bannerContainer;
@property (nonatomic, strong) MASConstraint* heightConstr;
@property (nonatomic, strong) NSFetchedResultsController* frc;


@property (nonatomic, strong) NSString* currentRoomId;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;


@property NSMutableArray *sectionChanges;
@property NSMutableArray *itemChanges;

@property (nonatomic, assign) NSInteger fetchLimit;

@property (nonatomic, strong) JSQMessagesBubbleImage* outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage* incomingBubbleImageData;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) BOOL isLoadOldMessage;

@property (nonatomic, strong) UIButton* locationButton;
@property (nonatomic, strong) UIButton* sendButton;
@property (nonatomic, strong) NSString* userId;

@property (nonatomic, assign) BOOL canShowUserInfo;

@property (nonatomic, strong) FBNativeAdView* adView;
//@property (nonatomic, strong) FRPrivateRoomHeaderView* userSinceView;

@property (nonatomic, strong) UIGestureRecognizer* tapForShowUser;

@end

typedef NS_ENUM(NSInteger, MenuType) {
    MenuTypeRemove,
    MenuTypeBlock,
    MenuTypeReport,
};


@implementation FRPrivateRoomChatVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
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

- (BOOL)isFriends {
    
    if ([self.eventHandler userEntity]) {
        
        CurrentUser *currentUser = [[FRUserManager sharedInstance] currentUser];
        UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:[self.eventHandler userEntity].objectID];
        
        return ([currentUser.friends containsObject:user] || user.isFriend.boolValue);
    }
    
    return false;
}

- (void)setupWithRoomId:(NSString*)roomId {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"roomId == %@", [self.eventHandler roomId]];
    self.frc = [FRPrivateMessage MR_fetchAllSortedBy:@"createDate" ascending:true withPredicate:predicate groupBy:nil delegate:self];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FRPrivateMessage"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:true]]];
    fetchRequest.predicate = predicate;
    [fetchRequest setFetchBatchSize:5];
    
    [[self.frc fetchRequest] setFetchBatchSize:5];
    NSError* error;
    [self.frc performFetch:&error];
 
}

- (void)userId:(NSString *)userId {
    self.userId = userId;
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
    
    if (self.canShowUserInfo) {
        [self.collectionView reloadData];
        self.canShowUserInfo = false;
        return;
    }
    
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
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                        
                    default: break;
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        
                        
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
                        
//                        } else {
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
//                        }
                        
//                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
//                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
//                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
        
        [CATransaction commit];
        
        [CATransaction setDisableActions:false];
        [CATransaction commit];
        
        if ( self.collectionView.contentSize.height <= self.collectionView.frame.size.height)
        {
            return ;
        }
       
        if (!self.isLoadOldMessage) {

            
            [self scrollToBottomAnimated:true];
            
        } else {
            
            self.isLoadOldMessage = false;
        }
    }];
        
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FRPrivateRoomHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
    
    
    
//    self.topCollectionViewConstr.constant = 80;
//    self.userSinceView = [[[NSBundle mainBundle] loadNibNamed:@"FRPrivateRoomHeaderView" owner:self options:nil] firstObject];
//    
//    
//    [self.view addSubview:self.userSinceView];
//    [self.userSinceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.bottom.equalTo(self.collectionView.mas_top);
//    }];
//    
//    [self.userSinceView updateWithUserEntity:[self.eventHandler userEntity]];
    
    self.tapForShowUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedUser)];
//    [self.userSinceView addGestureRecognizer:tap];
    
    [[UINavigationBar appearance] setTintColor:[UIColor bs_colorWithHexString:@"#939BAF"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:false];
    
    [[UINavigationBar appearance] setShadowImage:[UIImageHelper imageFromColor:[UIColor bs_colorWithHexString:@"E4E6EA"]]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"00B4FB"]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"EEF1F7"]];


    [self.inputToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.inputToolbar setShadowImage:[UIImageHelper imageFromColor:[UIColor bs_colorWithHexString:@"E4E6EA"]] forToolbarPosition:UIBarPositionAny];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.heightForAd = 0;
    self.toolbarBottomLayoutGuide.constant = 0;
    
    [self.collectionView registerClass:[FRPrivateChatUserHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"FRPrivateChatUserHeader"];
    
    self.navigationItem.titleView = self.titleView;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor bs_colorWithHexString:@"#939BAF"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.collectionView.alwaysBounceVertical = YES;
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    self.navigationController.navigationBarHidden = NO;
    self.senderId = [FRUserManager sharedInstance].userId;
    self.senderDisplayName = @"senderDisplayName";
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    self.inputToolbar.maximumHeight = 110;
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.showLoadEarlierMessagesHeader = NO;
    
    UIImage* imageBack = [UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageBack
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.eventHandler
                                                                            action:@selector(backSelected)];
    
    
    UIButton* leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButton.layer.cornerRadius = 15;
    leftButton.backgroundColor = [UIColor whiteColor];
//    self.inputToolbar.contentView.leftBarButtonItem = self.leftButton;
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
//    [self.inputToolbar.contentView.leftBarButtonContainerView addSubview:self.leftButton];
    
    NSURL* userPhoto = [NSURL URLWithString:[NSObject bs_safeString:[[FRUserManager sharedInstance].currentUser userPhoto]]];
    
    
    [self.leftButton.imageView sd_setImageWithURL:userPhoto];
    
    
    self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, 30, 30)];
    [self.sendButton setImage:[FRStyleKit imageOfSenddisabledCanvas] forState:UIControlStateDisabled];
    [self.sendButton setImage:[FRStyleKit imageOfSendMessageOnCanvas] forState:UIControlStateNormal];
    
    self.locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    [locationButton setImage:[FRStyleKit imageOfSendMessageOffCanvas] forState:UIControlStateDisabled];
    [self.locationButton setImage:[FRStyleKit imageOfSendlocationCanvas] forState:UIControlStateNormal];
    
    [self.locationButton addTarget:self action:@selector(shareLocation) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.inputToolbar.contentView.rightBarButtonItem = self.sendButton;
    
    [self.inputToolbar.contentView.rightBarButtonContainerView addSubview: self.locationButton];
    //    [self.inputToolbar.contentView.rightBarButtonContainerView addSubview: rightButton];
    
    self.inputToolbar.contentView.rightBarButtonItemWidth = 70;
//    self.inputToolbar.contentView.leftBarButtonItemWidth = 30;
//    self.inputToolbar.contentView.rightBarButtonItem.layer.cornerRadius = 35;
    
    UIImage* imageOptions = [UIImageHelper image:[FRStyleKit imageOfFeildMoreOptionsCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:imageOptions
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(showActionSheet:)];
    
    
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
    
    
    if ([FRUserManager sharedInstance].canShowAdvertisement && ![self.userId isEqualToString:WELCOME_TEMP_USER])
    {
        [self showAdvertisement];
    }
    if ([self.userId isEqualToString:WELCOME_TEMP_USER]) {
        self.inputToolbar.hidden = true;
    }
    
    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:[FRUserManager sharedInstance].currentUser.userPhoto]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.leftButton setImage:image forState:UIControlStateNormal];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageStatus:) name:kUpdateMessageStatus object:nil];
    
    if ([FRUserManager sharedInstance].canShowAdvertisement)
    {
        [FRAnimator animateConstraint:self.heightConstr newOffset:50 key:@"(NSString*)key"];
        
        self.heightForAd = 50;
        self.toolbarBottomLayoutGuide.constant = 50;
    }
    
    
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
 
    if ([[self.collectionView visibleCells] count] > 0) {
        
        BSDispatchBlockAfter(1, ^{
            
//            [self.collectionView reloadItemsAtIndexPaths:@[[self.collectionView indexPathForCell:[[self.collectionView visibleCells] lastObject]]]];
                    [self.collectionView reloadData];
        });
    }

    
}

- (void)updatePrivateHeader:(FRPrivateChatUserHeaderViewModel*)model
{
    self.headerPrivateViewModel = model;
}

- (void)selectedUser {
    
    if ([self.userId isEqualToString:@"WELCOM_TEMP_USER"]){
        return;
    }
    
    [self.eventHandler showUserProfile:self.userId];
    
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

- (void)updateWithGroup:(FRGroupRoom*)groupRoom
{
    self.groupRoom = groupRoom;
}


- (UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (!self.frc.fetchedObjects.count && self.headerPrivateViewModel)
        {
            FRPrivateChatUserHeader* reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FRPrivateChatUserHeader" forIndexPath:indexPath];
                
            if (reusableview==nil){
                    reusableview = [[FRPrivateChatUserHeader alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 250)];
            }
            [reusableview updateWithModel:self.headerPrivateViewModel];
            return reusableview;
        } else if (indexPath.row == 0 && indexPath.section == 0){
            
            
          FRPrivateRoomHeaderView* header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            
            [header updateWithUserEntity:[self.eventHandler userEntity]];
            
            [header addGestureRecognizer:self.tapForShowUser];
            return header;
        }
    }
    
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    //TODO: sectionCount // !self.dataMessages.messages.count
    
        
        if (!self.frc.fetchedObjects.count && self.headerPrivateViewModel && ![self.userId isEqualToString:@"WELCOM_TEMP_USER"])
        {
            self.topCollectionViewConstr.constant = 0;
//            self.userSinceView.hidden = true;
            self.canShowUserInfo = true;
            return CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 250);
        } else if (section == 0 && ![self.userId isEqualToString:@"WELCOM_TEMP_USER"]) {
            
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
        }
    
    if (![self.userId isEqualToString:@"WELCOM_TEMP_USER"]) {
        
        self.topCollectionViewConstr.constant = 80;
//        self.userSinceView.hidden = false;
    }else {
        self.topCollectionViewConstr.constant = 0;
//        self.userSinceView.hidden = true;
    }
    
        return CGSizeZero;
    
}


- (UIView*)titleView
{
    if (!_titleView)
    {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        label.font = FONT_SF_DISPLAY_MEDIUM(16);
        [label setText:self.titleString];
        
        [_titleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_titleView);
        }];
        
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedUser)];
        
        [_titleView addGestureRecognizer:gest];
        
        UIImageView* im = [UIImageView new];
        
        [im sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:self.titleImage]]];
        im.clipsToBounds = YES;
        im.contentMode = UIViewContentModeScaleAspectFill;
        im.layer.cornerRadius = 12;
        [_titleView addSubview:im];
        
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(label.mas_left).offset(-3);
            make.width.height.equalTo(@24);
        }];
    }
    return _titleView;
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

- (void)updateTitle:(NSString*)title image:(NSString*)imageUrl
{
    
    self.titleString = title;
    self.titleImage = imageUrl;
}

- (void)updateGroupHeader:(FRGroupUsersHeaderViewModel*)model
{
    self.headerViewModel = model;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    setStatusBarColor([UIColor blackColor]);
    
    [self.eventHandler viewWillAppear];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    
    if ([self.userId isEqualToString:WELCOME_TEMP_USER]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    NSArray* allMessage = [FRPrivateMessage MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"roomId == %@ OR messageStatus == %@", [self.eventHandler roomId], @(2)]
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    
    
    for (FRPrivateMessage* message in allMessage) {
        message.messageStatus = @(3);
        [FRDataBaseManager readMessage:message];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.eventHandler backSelected];
}

- (void)recivedMessage:(JSQMessage*)message
{
//    [self.dataMessages.messages addObject:message];
    
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    [self finishReceivingMessageAnimated:YES];
    
    if (message.isMediaMessage)
    {
        BSDispatchBlockAfter(2, ^{
            
            [self.collectionView reloadData];
        });
    }
}

- (void)shareLocation
{
    if ([self.userId isEqualToString:@"WELCOM_TEMP_USER"]) {
    
        return;
    }
    
    if (![self isFriends]) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You can not send messages" message:@"The user has to be your friend." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
    [self.eventHandler shareLocation];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    BSDispatchBlockAfter(0.8, ^{
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void)showActionSheet:(UIBarButtonItem *)sender
{
    if ([self.userId isEqualToString:@"WELCOM_TEMP_USER"]) {
        return;
    }
    
    if (![self isFriends]) {
        return;
    }
    
    [self.view endEditing:YES];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:FRLocalizedString(@"Option", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* shareLocation = [UIAlertAction actionWithTitle:FRLocalizedString(@"Share location", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.eventHandler shareLocation];
    }];
    
    UIAlertAction* remove = [UIAlertAction actionWithTitle:FRLocalizedString(@"Remove user", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithType:MenuTypeRemove];
    }];
    
    UIAlertAction* block = [UIAlertAction actionWithTitle:FRLocalizedString(@"Block user", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithType:MenuTypeBlock];
    }];
    
    UIAlertAction* report = [UIAlertAction actionWithTitle:FRLocalizedString(@"Report user", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithType:MenuTypeReport];
    }];
    
    UIAlertAction* inviteToEvent = [UIAlertAction actionWithTitle:FRLocalizedString(@"Invite to event", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.eventHandler inviteToUser];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:FRLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:shareLocation];
//    [alert addAction:remove];
    [alert addAction:block];
    [alert addAction:report];
    [alert addAction:inviteToEvent];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showAlertWithType:(MenuType)type {
    
    NSString* message;
    switch (type) {
        case MenuTypeRemove:
        {
            message = FRLocalizedString(@"Are you sure you want to remove this user?", nil);
        }   break;
            
        case MenuTypeBlock:
        {
            message = FRLocalizedString(@"Are you sure you want to block this user?", nil);
        }   break;
        
        case MenuTypeReport:
        {
            message = FRLocalizedString(@"Are you sure you want to report this user?", nil);

        }   break;
            
        default:
            break;
    }
  
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Warning", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        switch (type) {
            case MenuTypeRemove:
            {
                [self.eventHandler removeUser];
            }   break;
                
            case MenuTypeBlock:
            {
                [self.eventHandler blockUser];
            }   break;
                
            case MenuTypeReport:
            {
                [self.eventHandler reportUser];
            }   break;
        }
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
    if ([self.userId isEqualToString:@"WELCOM_TEMP_USER"]) {
        return;
    }
    
    
    if (![self isFriends]) {
        
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You can not send messages" message:@"The user has to be your friend." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
            }];
            
            [alert addAction:cancel];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                             senderDisplayName:senderDisplayName
//                                                          date:date
//                                                          text:text];
//    [self.dataMessages.messages addObject:message];
    
    [self frc];
    [self.eventHandler sendMessage:text];
    
    [self finishSendingMessageAnimated:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    BSDispatchBlockAfter(0.8, ^{
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

#pragma mark - User Interface

- (void)updateDataSource:(FRPrivateChatDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FRBaseMessage *entity = [self.frc objectAtIndexPath:indexPath];
    
    if ([entity.creatorId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
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

    return (id)((FRPrivateMessage*)entity).room.opponent.userPhoto;
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
    
    
    if (indexPath.row == self.frc.fetchedObjects.count - 1){
        id entity =  [self.frc objectAtIndexPath:indexPath];
        JSQMessage* message = [self.eventHandler createJSQMessage:entity];
        if ([message.senderId isEqualToString: self.senderId])
        {
            return 30.0f;
        }
    }
    
    return 0;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    id entity =  [self.frc objectAtIndexPath:indexPath];
    JSQMessage *message = [self.eventHandler createJSQMessage:entity];
    
    if (message.messageStatus == FRMessageStatusDelivered) {
        [FRDataBaseManager readMessage:entity];
    }
    NSLog(@"%ld", (long)message.messageStatus);
    
    if (indexPath.row == self.frc.fetchedObjects.count - 1){
        
        
        
        NSString* statusMes = nil;
        switch (message.messageStatus) {
            case FRMessageStatusCreated:
            case FRMessageStatusSend:
            {
                statusMes = @"Sent";
            } break;
            case FRMessageStatusDelivered:
            {
                statusMes = @"Delivered";
            } break;
            case FRMessageStatusRead:
            {
                statusMes = @"Read";
            } break;
                
            default:
                break;
        }
        
        return [[NSAttributedString alloc] initWithString:statusMes];
    }
    return nil;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.frc.fetchedObjects count];
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
    
    /**
     *  Don't specify attributes to use the defaults.
     */
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
    if (!indexPath.item || [self showTimeForIndexPath:indexPath]){
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  iOS7-style sender name labels
     */
//    JSQMessage *currentMessage = [self.dataMessages.messages objectAtIndex:indexPath.item];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return  UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
