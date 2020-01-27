//
//  HomeCollectionViewCell.m
//  Project
//
//  Created by Jane Doe on 2/29/16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import "FREventPreviewEventViewCell.h"
#import "FRStyleKit.h"
#import "FREventPreviewDateView.h"
#import "UIImageView+AFNetworking.h"
#import "FREventPreviewAttendingSmallCollectionCell.h"
#import "FREventPreviewAttendingSmallFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "FRDistanceLabel.h"
#import "FREventOpenSlotsCollectionViewCell.h"
#import "UIImageHelper.h"
#import "FRUserManager.h"
#import "FRJoinUserCollectionCell.h"

@interface FREventPreviewEventViewCell() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIImageView* avatar;
@property (strong, nonatomic) UIImageView* partnerAvatar;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) FRDistanceLabel* distanceLabel;
@property (strong, nonatomic) UIButton* typeButton;
@property (strong, nonatomic) UIImageView* genderImage;
@property (strong, nonatomic) FREventPreviewEventViewCellViewModel* model;

@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UICollectionView* smallAttendingCollectionView;
@property (strong, nonatomic) FREventPreviewDateView* dateView;

@property (strong, nonatomic) NSArray* usersList;
@property (nonatomic, strong) NSString* urlImage;
@property (nonatomic, assign) NSInteger usersCount;

@end

static NSString* const kCellJoinUserId = @"kCellJoinUserId";
static NSString* const kCellOpenSlotsId = @"kCellOpenSlotsId";

@implementation FREventPreviewEventViewCell

- (void)hideAllSubviews {
    
    BOOL isHide = true;
    self.titleLabel.hidden = isHide;
    self.distanceLabel.hidden = isHide;
    self.genderImage.hidden = isHide;
    self.avatar.hidden = isHide;
    self.partnerAvatar.hidden = isHide;
    self.typeButton.hidden = isHide;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self downView];
        [self smallAttendingCollectionView];
        [self joinButton];
        [self frontground];
//        self.autoresizesSubviews = YES;
        self.contentView.clipsToBounds = false;
        self.backgroundView.clipsToBounds = false;
        self.headerView.clipsToBounds = true;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self overlayImage];
        [self titleLabel];
        [self distanceLabel];
        [self avatar];
        [self headerView];
        [self typeButton];
        self.partnerAvatar.hidden = YES;
        [self genderImage];
       
        [self dateView];
        [self separator];
        
        self.clipsToBounds = false;
        self.contentView.clipsToBounds = false;
    }
    return self;
}

- (void) joinedAction
{
    if ([self.joinButton.titleLabel.text isEqual: @"Join"])
    {
        NSString* gender = [FRUserManager sharedInstance].userModel.gender;
        NSString* genderIntegerValue = [NSString new];
        if ([gender isEqualToString:@"male"])
        {
            genderIntegerValue = @"1";
            gender = @"female";
        }
        else
        {
            genderIntegerValue = @"2";
            gender = @"male";
        }
        if (![self.model.gender isEqualToString:@"0"]&![self.model.gender isEqualToString:genderIntegerValue])
        {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ops" message:[NSString stringWithFormat:@"Ops it looks like the guest has only opened it to %@s", gender] delegate:self
                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
        [self.delegate showJoinRequest];
        }
    }
}

- (void) showUserProfile
{
    [self.delegate showUserProfile:self.model.creator.user_id];
}

- (void) showPartnerProfile
{
    [self.delegate showUserProfile:self.model.partner_hosting];
}

- (void)updateEventImage:(UIImage*)eventImage
{
    self.headerView.image = eventImage;
}

- (void) updateWithModel:(FREventPreviewEventViewCellViewModel*)model
{
    self.model = model;
    
    if (![self.urlImage isEqualToString:model.backImage]) {
        
        self.urlImage = model.backImage;
        
        NSURL* urlForHeader = [NSURL URLWithString:model.backImage];
        [self.headerView sd_setImageWithURL:urlForHeader
                           placeholderImage:[FRStyleKit imageOfArtboard121Canvas]
                                  completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (image1)
                                      {
                                          self.headerView.image = image1;
                                      }
                                  }];
    }
    
    
    self.titleLabel.text = model.title;
    
    NSURL* url = [NSURL URLWithString:model.creatorAvatar];
    [self.avatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            self.avatar.image = image;
        }
    }];
    UIImage* image = nil;
    
    if ([model.gender integerValue] == FRGenderTypeAll)
    {
        image = [FRStyleKit imageOfSexBoth];
    }
    else if([model.gender integerValue] == FRGenderTypeMale)
    {
        image = [FRStyleKit imageOfSexMaleOnCanvas];
    }
    else if ([model.gender integerValue] == FRGenderTypeFemale)
    {
        image = [FRStyleKit imageOfSexFemaleOnCanvas];
    }
    
    [self.genderImage setImage:image];
    [self.genderImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.genderImage.image.size.width / 2));
    }];
    
    [self smallAttendingCollectionView];
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.model.users];
    self.usersCount = array.count;
    
    [array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];
    
    [array addObject:@(self.model.slots)];
    
    
    
    [self typeButton];
    [self _setEventType:[model.event_type integerValue]];
    
    [self _setEventRequestStatusType:[model.request_status integerValue]];
    [self.distanceLabel setText:model.distance];
    self.usersList = [self _changeUsersArray:array];
    
    [self.dateView updateWithModel:model];
    if ((model.partner_hosting != nil)&&([model.partner_is_accepted isEqualToString:@"1"]))
    {
        [self _updateWithPartner];
         NSURL* url = [NSURL URLWithString:model.partner.photo];
        [self.partnerAvatar sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            self.partnerAvatar.image = image;
        }
    }];

        
    }
    [self.smallAttendingCollectionView reloadData];
    if (([self.model.creator.user_id isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].userModel.id]])||([self.model.partner_hosting isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].userId]]))
    {
        self.joinButton.hidden = YES;
    }
    if ((model.users.count == [model.event.slots integerValue])&(self.model.request_status==nil))
    {
         self.joinButton.hidden = YES;
    }
}

- (NSArray*)_changeUsersArray:(NSArray*)users
{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger count = [UIScreen mainScreen].bounds.size.width <= 568.f ? 3 : 5;
    
    [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > count)
        {
            *stop = YES;
        }
        [array addObject:obj];
    }];
    
    return array;
}

- (void)_updateWithPartner
{
    [self.avatar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-25);
    }];
    self.partnerAvatar.hidden = NO;
}

- (void)_setEventType:(FREventType)eventType
{
    switch (eventType){
        case FREventTypeNew:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   NEW   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        } break;
            
        case FREventTypeFeatured:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   FEATURED   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        } break;
            
        case FREventTypePopular:
        {
            [self.typeButton setTitle:FRLocalizedString(@"   POPULAR   ", nil) forState:UIControlStateNormal];
            self.typeButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        } break;
    }
}

- (void)_setEventRequestStatusType:(FREventRequestStatusType)eventRequestStatusType
{
    switch (eventRequestStatusType){
        case FREventRequestStatusAvailableToJoin:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
            [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusPending:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Pending" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusAccepted:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
            [self.joinButton setTitle:@"Attending" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } break;
            
        case FREventRequestStatusDeclined:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
            [self.joinButton setTitle:@"Declined" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusUnsubscribe:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } break;
        case FREventRequestStatusDiscard:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Discard" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        } break;
            
        default: {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"NoState" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            
    }
}

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        if (self.usersList.count>=5)
        {
            return 4;
        }
        else
        {
            return self.usersList.count-1;
        }
    }
    else
        return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        FREventOpenSlotsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellOpenSlotsId forIndexPath:indexPath];
        [cell updateWithModel:self.model.slots];
        return cell;
    }
    else
    {
        
        
        if (((self.usersList.count - 2) == indexPath.row) &&
            (((self.usersCount - (NSInteger)self.usersList.count)) > 1)){
            
            FRJoinUserEmptyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRJoinUserEmptyCollectionCell" forIndexPath:indexPath];
            
            [cell updateWithCount:(self.usersCount - self.usersList.count + 2)];
            cell.layer.zPosition = self.usersList.count-1 - indexPath.row;
            cell.layer.borderWidth = 2;
            return cell;
        }
        
        
    FREventPreviewAttendingSmallCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellJoinUserId forIndexPath:indexPath];
    [cell updateWithModel:[self.usersList objectAtIndex:indexPath.row]];
        
         cell.layer.zPosition = self.usersList.count-1 - indexPath.row;
        
        return cell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(28, 28);
}



#pragma mark - LazyLoad

- (UIView*)frontground
{
    if (!_frontground)
    {
        _frontground = [UIView new];
        _frontground.backgroundColor = [UIColor blackColor];
        _frontground.alpha = 0;
        [self.contentView addSubview:_frontground];
        [_frontground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.height * 2));
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        }];
    }
    return _frontground;
}
-(UIImageView*) genderImage
{
    if (!_genderImage)
    {
        _genderImage = [UIImageView new];
        _genderImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.headerView addSubview:_genderImage];
        [_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headerView).offset(-15);
            make.right.equalTo(self.headerView).offset(-15);
            make.height.equalTo(@25);
        }];
    }
    return _genderImage;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 3;
        [_titleLabel sizeToFit];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _titleLabel.shadowOffset = CGSizeMake(-1.5, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor whiteColor]];

        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(50);
        [self.headerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
         //   make.centerX.equalTo(self);
//            make.left.equalTo(self.headerView).offset(40);
//            make.right.equalTo(self.headerView).offset(-40);
            make.centerX.equalTo(self.headerView);
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width - 80));
            
            make.height.lessThanOrEqualTo(@120);
        }];
    }
    return _titleLabel;
}

-(FRDistanceLabel*) distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [FRDistanceLabel new];
        [_distanceLabel setText:@" 13KM AWAY"];
        _distanceLabel.font = FONT_SF_DISPLAY_BOLD(12);
        [_distanceLabel setTextColor:[UIColor whiteColor]];
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.clipsToBounds = YES;
        [_distanceLabel setBackgroundColor:[[UIColor bs_colorWithHexString:@"1F1451"] colorWithAlphaComponent:1]];
        [self.headerView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@20);
            //            make.bottom.equalTo(self.eventImage).offset(-35);
            make.width.lessThanOrEqualTo(@200);
        }];
    }
    return _distanceLabel;
}

-(UIButton*) typeButton
{
    if (!_typeButton)
    {
        _typeButton = [UIButton new];
        [_typeButton setBackgroundColor:[UIColor bs_colorWithHexString:@"#F6890A"]];
        _typeButton.layer.cornerRadius = 3;
        [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      //  [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [_typeButton setTitle:@"FEATURED" forState:UIControlStateNormal];
        _typeButton.titleLabel.font = FONT_SF_DISPLAY_BOLD(10);
        [self.headerView addSubview:_typeButton];
        [_typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
    //            make.width.equalTo(@65);
            make.left.equalTo(self.headerView).offset(10);
            make.bottom.equalTo(self.headerView).offset(-15);

        }];
    }
    return _typeButton;
}

-(UIImageView*) avatar
{
    if (!_avatar)
    {
        _avatar = [UIImageView new];
        _avatar.layer.cornerRadius = 37.5;
        _avatar.clipsToBounds = YES;
        _avatar.backgroundColor = [UIColor blackColor];
        _avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatar.layer.borderWidth = 3;
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatar addGestureRecognizer:singleTap];
        _avatar.userInteractionEnabled = YES;
        _avatar.contentMode = UIViewContentModeScaleToFill;
        [self.headerView insertSubview:_avatar aboveSubview:self.partnerAvatar];
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-10);
//            make.top.equalTo(self).offset(25);
            make.width.height.equalTo(@75);
        }];
    }
    return _avatar;
}

-(UIImageView*) partnerAvatar
{
    if (!_partnerAvatar)
    {
        _partnerAvatar = [UIImageView new];
        _partnerAvatar.layer.cornerRadius = 37.5;
        _partnerAvatar.clipsToBounds = YES;
        _partnerAvatar.backgroundColor = [UIColor blackColor];
        _partnerAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        _partnerAvatar.layer.borderWidth = 3;
        UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPartnerProfile)];
        [singleTap1 setNumberOfTapsRequired:1];
        [_partnerAvatar addGestureRecognizer:singleTap1];
        _partnerAvatar.userInteractionEnabled = YES;
        _partnerAvatar.contentMode = UIViewContentModeScaleToFill;
        [self.headerView addSubview:_partnerAvatar];
        [_partnerAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(25);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-10);
//            make.top.equalTo(self).offset(25);
            make.width.height.equalTo(@75);
        }];
    }
    return _partnerAvatar;
}

-(UIImageView*) headerView
{
    if (!_headerView)
    {
        _headerView = [UIImageView new];
        _headerView.clipsToBounds = YES;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.userInteractionEnabled = YES;
       // [_headerView setBackgroundColor:[UIColor magentaColor]];
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.downView.mas_top);
        }];
    }
    return _headerView;
}

-(UIView*) downView
{
    if (!_downView)
    {
        _downView = [UIView new];
        _downView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_downView];
        [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@54.5);
        }];
    }
    return _downView;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self.downView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.downView);
            make.right.equalTo(self.downView).offset(-10);
            make.left.equalTo(self.downView).offset(10);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(FREventPreviewDateView*) dateView
{
    if (!_dateView)
    {
        _dateView = [FREventPreviewDateView new];
        [self.downView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downView);
            make.left.equalTo(self.downView).offset(5);
            make.width.height.equalTo(@50);
        }];
    }
    return _dateView;
}

-(UIButton*) joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
        _joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinButton addTarget:self action:@selector(joinedAction) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _joinButton.layer.cornerRadius = 4;
        [self addSubview:_joinButton];
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downView);
            make.right.equalTo(self.downView).offset(-10);
            make.height.equalTo(@35);
            make.width.equalTo(@90);
        }];
    }
    return _joinButton;
}


#pragma mark - collectionView

- (UICollectionView*) smallAttendingCollectionView
{
    if (!_smallAttendingCollectionView)
    {
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        _smallAttendingCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [layout setMinimumLineSpacing:-7];
        [layout setSectionInset:UIEdgeInsetsMake(10, 5, 10, 0)];

       [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [_smallAttendingCollectionView registerClass:[FREventPreviewAttendingSmallCollectionCell class] forCellWithReuseIdentifier:kCellJoinUserId];
           [_smallAttendingCollectionView registerClass:[FREventOpenSlotsCollectionViewCell class] forCellWithReuseIdentifier:kCellOpenSlotsId];
        
        [_smallAttendingCollectionView registerClass:[FRJoinUserEmptyCollectionCell class] forCellWithReuseIdentifier:@"FRJoinUserEmptyCollectionCell"];
        
        [_smallAttendingCollectionView setDataSource:self];
        [_smallAttendingCollectionView setDelegate:self];
        
        [_smallAttendingCollectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.downView addSubview:_smallAttendingCollectionView];
        
        [_smallAttendingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downView).offset(10);
            make.left.equalTo(self.dateView.mas_right).offset(15);
            make.right.equalTo(self.joinButton.mas_left).offset(-10);
            make.bottom.equalTo(self.downView).offset(-10);
        }];
    }
    return _smallAttendingCollectionView;
}

-(UIImageView*)overlayImage
{
    if (!_overlayImage)
    {
        _overlayImage = [UIImageView new];
        _overlayImage.contentMode = UIViewContentModeScaleToFill;
        [_overlayImage setImage:[UIImage imageNamed:@"over-normal-event.png"]];
        [self.headerView addSubview:_overlayImage];
        [_overlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.headerView);
            make.left.top.right.equalTo(self.headerView);
            make.height.equalTo(self.headerView);
        }];
    }
    return _overlayImage;
}

@end
