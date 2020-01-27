//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventDataSource.h"
#import "BSMemoryStorage.h"
#import "FRCreateEventViewConstants.h"

#import "FRCreateEventAddImageCellViewModel.h"
#import "FRCreateEventTextViewCellViewModel.h"
#import "FRCreateEventAgeCellViewModel.h"
#import "FRCreateEventPartnerHostingCellViewModel.h"
#import "FRCreateEventOpenToFBCellViewModel.h"
#import "FRCreateEventInformationCellViewModel.h"
#import "FRCreateEventIconDataCellViewModel.h"
#import "FRStyleKit.h"
#import "FRCreateEventShowNumberCellViewModel.h"
#import "FRCreateEventInviteCellViewModel.h"
#import "FRCreateEventCreateActionCellViewModel.h"
#import "FREventModel.h"
#import "FRCreateEventLocationPlaceModel.h"
#import "FREventPreviewAttendingViewModel.h"

#import "FRDateManager.h"
#import "FRCreateEventLocationDomainModel.h"

#import "FRGalleryModel.h"

@interface FRCreateEventDataSource ()
<
    FRCreateEventAddImageCellViewModelDelegate,
    FRCreateEventTextViewCellViewModelDelegate,
    FRCreateEventInviteCellViewModelDelegate
>

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) FREvent* editingEvent;

@end

@implementation FRCreateEventDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)verifyFields
{
   NSString* ver = [self _verifyField:[self event]];
    
    if (ver.length >0)
    {
        ver = [ver substringToIndex:[ver length] - 1];
        if ([ver containsString:@","])
        {
            ver = [ver stringByAppendingString:@" are required"];
        }
        else
        {
            ver = [ver stringByAppendingString:@" is required"];
        }
        [self.delegate showVerifyAlert:ver];
    }
    else
    {
        [self.delegate createEventSelected];
    }
}

- (void)setupStorage
{
    self.isEdit = NO;
    
    FRCreateEventAddImageCellViewModel* addImageModel = [FRCreateEventAddImageCellViewModel new];
    addImageModel.delegate = self;
    addImageModel.photo = [FRStyleKit imageOfCreateEventPlaceholder];
    [self.storage addItem:addImageModel];
    
    FRCreateEventTextViewCellViewModel* titleModel = [FRCreateEventTextViewCellViewModel new];
    titleModel.type = FRCreateEventCellTypeTitle;
    titleModel.placeholder = FRLocalizedString(@"What are you hosting?", nil);
    titleModel.delegate = self;
    titleModel.maxCharacter = 40;
    [self.storage addItem:titleModel];
    
    
    FRCreateEventTextViewCellViewModel* descriptionModel = [FRCreateEventTextViewCellViewModel new];
    descriptionModel.type = FRCreateEventCellTypeDescription;
    descriptionModel.placeholder = FRLocalizedString(@"Description...", nil);
    descriptionModel.delegate = self;
    descriptionModel.maxCharacter = 200;
    [self.storage addItem:descriptionModel];
    
    FRCreateEventAgeCellViewModel* genderModel = [FRCreateEventAgeCellViewModel new];
    genderModel.title = FRLocalizedString(@"Gender", nil);
    genderModel.type = FRCreateEventCellTypeGender;
    [self.storage addItem:genderModel];


    FRCreateEventAgeCellViewModel* agesModel = [FRCreateEventAgeCellViewModel new];
    agesModel.title = FRLocalizedString(@"Age's", nil);
    agesModel.type = FRCreateEventCellTypeAges;
    agesModel.contentTitle = FRLocalizedString(@"All", nil);
    agesModel.contentArray = @[@18, @50];
    [self.storage addItem:agesModel];

    
    FRCreateEventAgeCellViewModel* openSlotsModel = [FRCreateEventAgeCellViewModel new];
    openSlotsModel.title = FRLocalizedString(@"Open slots", nil);
    openSlotsModel.isRequired = YES;
    openSlotsModel.type = FRCreateEventCellTypeOpenSlots;
    [self.storage addItem:openSlotsModel];

    
    FRCreateEventAgeCellViewModel* categoryModel = [FRCreateEventAgeCellViewModel new];
    categoryModel.title = FRLocalizedString(@"Category", nil);
    categoryModel.isRequired = YES;
    categoryModel.type = FRCreateEventCellTypeCategory;
    [self.storage addItem:categoryModel];

    
    FRCreateEventAgeCellViewModel* inviteModel = [FRCreateEventAgeCellViewModel new];
    inviteModel.title = FRLocalizedString(@"Invite friends", nil);    
    inviteModel.type = FRCreateEventCellTypeInviteFriends;
    [self.storage addItem:inviteModel];
    
    FRCreateEventPartnerHostingCellViewModel* parentHostingModel = [FRCreateEventPartnerHostingCellViewModel new];
    
    [self.storage addItem:parentHostingModel];
    
    FRCreateEventOpenToFBCellViewModel* openToFBModel = [FRCreateEventOpenToFBCellViewModel new];
    openToFBModel.isOpen = NO;
    [self.storage addItem:openToFBModel];
    

    FRCreateEventInformationCellViewModel* eventInfoModel = [FRCreateEventInformationCellViewModel new];
    [self.storage addItem:eventInfoModel];
    
    
    FRCreateEventIconDataCellViewModel* dateModel = [FRCreateEventIconDataCellViewModel new];
    dateModel.icon = [FRStyleKit imageOfCombinedShapeCanvas11];
    dateModel.title = FRLocalizedString(@"Date", nil);
    dateModel.type = FRCreateEventCellTypeDate;
    [self.storage addItem:dateModel];
    
    FRCreateEventIconDataCellViewModel* locationModel = [FRCreateEventIconDataCellViewModel new];
    locationModel.icon = [FRStyleKit imageOfCreateEventNewLocationIcon];
    locationModel.title = FRLocalizedString(@"Location", nil);
    locationModel.type = FRCreateEventCellTypeLocation;
    locationModel.hideTextField = YES;
    [self.storage addItem:locationModel];
    
    FRCreateEventIconDataCellViewModel* timeModel = [FRCreateEventIconDataCellViewModel new];
    timeModel.icon = [FRStyleKit imageOfFeildTimeCanvas];
    timeModel.title = FRLocalizedString(@"Time", nil);
    timeModel.type = FRCreateEventCellTypeTime;
    [self.storage addItem:timeModel];
    
    FRCreateEventShowNumberCellViewModel* showNumberModel = [FRCreateEventShowNumberCellViewModel new];
    showNumberModel.title = FRLocalizedString(@"Show number", nil);
    showNumberModel.icon = [FRStyleKit imageOfFeildNumberCanvas];
    showNumberModel.isSelected = NO;
    [self.storage addItem:showNumberModel];
    
    FRCreateEventInviteCellViewModel* eventInviteModel = [FRCreateEventInviteCellViewModel new];
    eventInviteModel.isForEditing = NO;
    eventInviteModel.delegate = self;
    eventInviteModel.featuredMode = FRCreateEventIvntiteTypeCannotFeatured;
    [self.storage addItem:eventInviteModel];
    
//    FRCreateEventCreateActionCellViewModel* eventActionModel = [FRCreateEventCreateActionCellViewModel new];
//    eventActionModel.canCreate = NO;
//    [self.storage addItem:eventActionModel];
}

- (void)updateFeature:(FREventFeatureModel*)model {
    FRCreateEventInviteCellViewModel* modelForCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypeInvite inSection:0]];
    
    if (![modelForCell isKindOfClass:[FRCreateEventInviteCellViewModel class]]) {
        modelForCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypeInvite + 1 inSection:0]];
    }
    modelForCell.fetureModel = model;
    if (model.create_featured_enable.boolValue && modelForCell.featuredMode != FRCreateEventIvntiteTypeCancelFeaured) {
        modelForCell.featuredMode = FRCreateEventIvntiteTypeCanFeatured;
    }
    [self.storage reloadItem:modelForCell];
}


- (void)setupStorageWithEvent:(FREvent*)event
{
    self.isEdit = YES;
    self.editingEvent = event;
    
    FRCreateEventAddImageCellViewModel* addImageModel = [FRCreateEventAddImageCellViewModel new];
    addImageModel.delegate = self;
    addImageModel.isShowSave = YES;
    addImageModel.photoUrl = event.imageUrl;
    [self.storage addItem:addImageModel];
    
    FRCreateEventTextViewCellViewModel* titleModel = [FRCreateEventTextViewCellViewModel new];
    titleModel.type = FRCreateEventCellTypeTitle;
    titleModel.placeholder = FRLocalizedString(@"What are you hosting?", nil);
    titleModel.delegate = self;
    titleModel.maxCharacter = 40;
    titleModel.content = event.title;
    [self.storage addItem:titleModel];
    
    
    FRCreateEventTextViewCellViewModel* descriptionModel = [FRCreateEventTextViewCellViewModel new];
    descriptionModel.type = FRCreateEventCellTypeDescription;
    descriptionModel.placeholder = FRLocalizedString(@"Description...", nil);
    descriptionModel.delegate = self;
    descriptionModel.maxCharacter = 200;
    descriptionModel.content = event.info;
    [self.storage addItem:descriptionModel];
    
    FRCreateEventAgeCellViewModel* genderModel = [FRCreateEventAgeCellViewModel new];
    genderModel.title = FRLocalizedString(@"Gender", nil);
    genderModel.type = FRCreateEventCellTypeGender;
    genderModel.gender = [event.gender integerValue];
    genderModel.contentArray = @[@([event.gender integerValue])];
    [self.storage addItem:genderModel];
    
    
    FRCreateEventAgeCellViewModel* agesModel = [FRCreateEventAgeCellViewModel new];
    agesModel.title = FRLocalizedString(@"Age's", nil);
    agesModel.type = FRCreateEventCellTypeAges;
    agesModel.contentTitle = [NSString stringWithFormat:@"%@-%@", event.ageMin.stringValue, event.ageMax.stringValue];
    agesModel.contentArray = @[event.ageMin, event.ageMax];
    [self.storage addItem:agesModel];
    
    
    FRCreateEventAgeCellViewModel* openSlotsModel = [FRCreateEventAgeCellViewModel new];
    openSlotsModel.title = FRLocalizedString(@"Open slots", nil);
    openSlotsModel.isRequired = YES;
    openSlotsModel.type = FRCreateEventCellTypeOpenSlots;
    openSlotsModel.contentTitle = event.slots.stringValue;
    openSlotsModel.contentArray = @[event.slots];
    [self.storage addItem:openSlotsModel];
    
    
    FRCreateEventAgeCellViewModel* categoryModel = [FRCreateEventAgeCellViewModel new];
    categoryModel.title = FRLocalizedString(@"Category", nil);
    categoryModel.isRequired = YES;
    categoryModel.type = FRCreateEventCellTypeCategory;
    categoryModel.contentTitle = event.category;
    categoryModel.contentArray = @[event.category];
    categoryModel.categoryId = event.categoryId;
    [self.storage addItem:categoryModel];
    
    
    FRCreateEventAgeCellViewModel* inviteModel = [FRCreateEventAgeCellViewModel new];
    inviteModel.title = FRLocalizedString(@"Invite friends", nil);
    inviteModel.type = FRCreateEventCellTypeInviteFriends;
    [self.storage addItem:inviteModel];
    
    FRCreateEventPartnerHostingCellViewModel* parentHostingModel = [FRCreateEventPartnerHostingCellViewModel new];
    inviteModel.type = FRCreateEventCellTypePartnerHosting;
    [self.storage addItem:parentHostingModel];
    
    FRCreateEventOpenToFBCellViewModel* openToFBModel = [FRCreateEventOpenToFBCellViewModel new];
    openToFBModel.isOpen = event.openToFBFriends;
    [self.storage addItem:openToFBModel];
    
    FRCreateEventInformationCellViewModel* eventInfoModel = [FRCreateEventInformationCellViewModel new];
    [self.storage addItem:eventInfoModel];
    
    
    FRCreateEventIconDataCellViewModel* dateModel = [FRCreateEventIconDataCellViewModel new];
    dateModel.icon = [FRStyleKit imageOfCombinedShapeCanvas11];
    dateModel.title = FRLocalizedString(@"Date", nil);
    dateModel.type = FRCreateEventCellTypeDate;
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM"];
    
    dateModel.content = [format stringFromDate:event.event_start];
    dateModel.dataString = dateModel.content;
    dateModel.dataArray = @[event.event_start];
    
    [self.storage addItem:dateModel];
    
    FRCreateEventIconDataCellViewModel* locationModel = [FRCreateEventIconDataCellViewModel new];
    locationModel.icon = [FRStyleKit imageOfCreateEventNewLocationIcon];
    locationModel.title = FRLocalizedString(@"Location", nil);
    locationModel.type = FRCreateEventCellTypeLocation;
    locationModel.hideTextField = YES;
    locationModel.content = event.address;
    locationModel.dataArray = @[event.lat, event.lon];
    [self.storage addItem:locationModel];
    
    FRCreateEventIconDataCellViewModel* timeModel = [FRCreateEventIconDataCellViewModel new];
    timeModel.icon = [FRStyleKit imageOfFeildTimeCanvas];
    timeModel.title = FRLocalizedString(@"Time", nil);
    timeModel.type = FRCreateEventCellTypeTime;
    NSString* stringTime = [FRDateManager timeStringFromServerDate:event.event_start];
    timeModel.content = stringTime;
    [self.storage addItem:timeModel];
    
    FRCreateEventShowNumberCellViewModel* showNumberModel = [FRCreateEventShowNumberCellViewModel new];
    showNumberModel.title = FRLocalizedString(@"Show number", nil);
    showNumberModel.icon = [FRStyleKit imageOfFeildNumberCanvas];
    showNumberModel.isSelected = event.showNumber.boolValue;
    [self.storage addItem:showNumberModel];
    
    FREventPreviewAttendingViewModel* attendingModel = [FREventPreviewAttendingViewModel initWithModel:event];
    [self.storage addItem:attendingModel];
    
    FRCreateEventInviteCellViewModel* eventInviteModel = [FRCreateEventInviteCellViewModel new];
    eventInviteModel.isForEditing = YES;
    eventInviteModel.delegate = self;
    eventInviteModel.featuredMode = event.isFeatured.boolValue ? FRCreateEventIvntiteTypeCancelFeaured : FRCreateEventIvntiteTypeCannotFeatured;
    
    [self.storage addItem:eventInviteModel];
    
//    FRCreateEventCreateActionCellViewModel* eventActionModel = [FRCreateEventCreateActionCellViewModel new];
//    eventActionModel.canCreate = YES;
//    [self.storage addItem:eventActionModel];
}

- (void)updateEventImage:(UIImage*)eventImage with:(FRPictureModel*)model
{
    FRCreateEventAddImageCellViewModel* addImageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    addImageModel.photo = eventImage;
    addImageModel.photoUrl = model.image_url;
    addImageModel.thumbnail = model.thumbnail_url;
    
    [self.storage reloadItem:addImageModel];
}

- (void)updateEventImage:(UIImage*)eventImage
{
    FRCreateEventAddImageCellViewModel* addImageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    addImageModel.photo = eventImage;
    addImageModel.photoUrl = nil;
    [self.storage reloadItem:addImageModel];
}

- (void)updateCategory:(NSString*)category andId:(NSString *)id
{
    FRCreateEventAgeCellViewModel* model = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypeCategory inSection:0]];
    model.contentTitle = category;
    model.categoryId = id;
    [self.storage reloadItem:model];
//    if (!self.isEdit)
//    {
        [self _verifyField:[self event]];
//    }
}

- (void)updateAgesMin:(NSInteger)min max:(NSInteger)max
{
    FRCreateEventAgeCellViewModel* agesModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    agesModel.contentTitle = [NSString stringWithFormat:@"%ld - %ld", (long)min, (long)max];
    agesModel.contentArray = @[@(min), @(max)];
    [self.storage reloadItem:agesModel];
}

- (void)updateGender:(FRGenderType)genderType
{
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    genderModel.gender = genderType;
    genderModel.contentArray = @[@(genderType)];
    [self.storage reloadItem:genderModel];
}

- (void)updateOpenSlots:(NSInteger)openSlots
{
    FRCreateEventAgeCellViewModel* openSlotsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    openSlotsModel.contentTitle = [NSString stringWithFormat:@"%ld", (long)openSlots];
    openSlotsModel.contentArray = @[@(openSlots)];
    [self.storage reloadItem:openSlotsModel];
    [self _verifyField:[self event]];
}

- (void)updateTime:(NSDate*)time
{
    FRCreateEventIconDataCellViewModel* timeModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0]];
    timeModel.content = [FRDateManager timeForCreateEvent:time];
//    NSTimeZone *tz = [NSTimeZone localTimeZone];
//    NSInteger seconds = -[tz secondsFromGMTForDate: time];
//    NSDate* timeUTC = [NSDate dateWithTimeInterval: seconds sinceDate: time];
    
    timeModel.dataArray = @[time];
    [self.storage reloadItem:timeModel];
        [self _verifyField:[self event]];
}

- (void)updateLocation:(FRCreateEventLocationDomainModel*)location
{
    FRCreateEventIconDataCellViewModel* locationModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    locationModel.content = location.placeName;
    locationModel.dataArray = @[@(location.coordinate.latitude), @(location.coordinate.longitude)];
    [self.storage reloadItem:locationModel];
    
    FRCreateEventAddImageCellViewModel* addImageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   
//    if (location.locationPhoto)
//    {
//        addImageModel.photo = location.locationPhoto;
//    }
    [self.storage reloadItem:addImageModel];
//    if (!self.isEdit)
//    {
        [self _verifyField:[self event]];
//    }
}

- (void)updateDate:(NSDate*)date
{
    FRCreateEventIconDataCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    
    dateModel.dataArray = @[date];
    dateModel.content = [FRDateManager dateForCreateEvent:date];
    dateModel.dataString = dateModel.content;
    [self.storage reloadItem:dateModel];
    [self _verifyField:[self event]];
}

- (void)updateInviteUsers:(NSArray*)friends
{
    FRCreateEventAgeCellViewModel* inviteFriendsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    NSString * result = [[friends valueForKey:@"description"] componentsJoinedByString:@", "];
    inviteFriendsModel.contentTitle = result;
    [self.storage reloadItem:inviteFriendsModel];
}

- (void)updateCoHost:(NSString*)partnerId :(NSString*)partnerName
{
    FRCreateEventPartnerHostingCellViewModel* parentHostingModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    parentHostingModel.partnerId = partnerId;
    parentHostingModel.contentTitle = partnerName;
    [self.storage reloadItem:parentHostingModel];
}

#pragma mark - GET 

- (NSArray*)ages
{
    FRCreateEventAgeCellViewModel* agesModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
   return agesModel.contentArray;
}

- (FRGenderType)gender
{
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    return genderModel.gender;
}

- (NSInteger)openSlots
{
    FRCreateEventAgeCellViewModel* openSlotsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    return [[openSlotsModel.contentArray firstObject] integerValue];
}

- (NSDate*)evendDate
{
     FRCreateEventIconDataCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    
    return [dateModel.dataArray firstObject];
}

- (NSDate*)eventTime
{
     FRCreateEventIconDataCellViewModel* timeModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0]];
//    return [timeModel.dataArray firstObject];
    NSString* time = timeModel.content;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm a"];
    NSDate *date = [dateFormat dateFromString:time];
    return date;
}

#pragma mark - Private


#pragma mark - FRCreateEventAddImageCellViewModelDelegate

- (void)selectedClose
{
    [self.delegate backSelected];
}

- (void)selectedUploadPhoto
{
    [self.delegate showPhotoPicker];
}

#pragma mark - FRCreateEventTextViewCellViewModelDelegate

- (void)changeTextContent:(NSString*)text type:(FRCreateEventCellType)type
{
    if (type == FRCreateEventCellTypeTitle)
    {
        
    }
    else if (type == FRCreateEventCellTypeDescription)
    {
        
    }
    [self _verifyField:[self event]];
}

- (void)selectedSave
{
    [self _verifyField:self.event];
    [self.delegate updateEventSelected];
}

#pragma mark - FRCreateEventInviteCellViewModelDelegate

- (void)deleteEvent
{
    [self.delegate deleteEvent];
}

- (void)pressInvite {
    [self.delegate inviteUsers];
}

- (void)pressFeature:(FRCreateEventInviteCellViewModel*)model {
    if (model.featuredMode == FRCreateEventIvntiteTypeCancelFeaured) {
        model.featuredMode = FRCreateEventIvntiteTypeCanFeatured;
    } else if (model.featuredMode == FRCreateEventIvntiteTypeCanFeatured) {
        model.featuredMode = FRCreateEventIvntiteTypeCancelFeaured;
    }
    
    [self.storage reloadItem:model];
}

- (FREventDomainModel*)event
{
    FREventDomainModel* event = [FREventDomainModel new];
    
    FRCreateEventAddImageCellViewModel* addImageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    event.placeImage = addImageModel.photo;
    event.thumbnail_url = addImageModel.thumbnail;
    event.image_url = addImageModel.photoUrl;
    
    FRCreateEventTextViewCellViewModel* titleModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    event.title = [titleModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRCreateEventTextViewCellViewModel* descriptionModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    event.info = [descriptionModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    event.gender = [[genderModel.contentArray firstObject] integerValue];
    
    FRCreateEventAgeCellViewModel* agesModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    event.age_min = [[agesModel.contentArray objectAtIndex:0] integerValue];
    event.age_max = [[agesModel.contentArray objectAtIndex:1] integerValue];
    
    FRCreateEventAgeCellViewModel* openSlotsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    event.slots = [[openSlotsModel.contentArray firstObject] integerValue];
    
    FRCreateEventAgeCellViewModel* categoryModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    event.category = categoryModel.contentTitle ? categoryModel.contentTitle : nil;
    event.category_id = categoryModel.categoryId ? categoryModel.categoryId : nil;
  
    FRCreateEventAgeCellViewModel* inviteModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];

    FRCreateEventPartnerHostingCellViewModel* parentHostingModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    event.partner_hosting = parentHostingModel.partnerId;
    
    FRCreateEventOpenToFBCellViewModel* openToFBModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    event.open_to_fb_friends = openToFBModel.isOpen;

    
    FRCreateEventIconDataCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    NSDate* date = [dateModel.dataArray firstObject];
    if (date) {
        NSDateFormatter* format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-dd MMM"];
        event.date_ = [format stringFromDate:date];
    }
    
    FRCreateEventIconDataCellViewModel* locationModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    event.locationName = locationModel.content;
    event.lat = [locationModel.dataArray.firstObject doubleValue];
    event.lon = [locationModel.dataArray.lastObject doubleValue];
    event.address = locationModel.content;
    
    FRCreateEventIconDataCellViewModel* timeModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0]];
//    NSString* time = [timeModel.dataArray firstObject];
    event.time_ = timeModel.content;
//    event.event_start = time;
//    time = [FRDateManager timeStringToServerDateString:event.time_];
    
    NSString* verifyDate = [FRDateManager eventStartStringFromDateString:[NSString stringWithFormat:@"%@-%@", event.date_, event.time_]];
    if (![verifyDate isEqualToString:@"0"]) {
          event.event_start = verifyDate;
    }
    else
    {
        event.event_start = [FRDateManager eventStartStringFromDate:[dateModel.dataArray firstObject]];
    }
    FRCreateEventShowNumberCellViewModel* showNumberModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0]];
    event.show_number = showNumberModel.isSelected;
 
//    NSString* emptyField = [self _verifyField:event];
//    if (emptyField.length)
//    {
//        [self.delegate emptyEventField:[emptyField substringWithRange:NSMakeRange(0, emptyField.length - 2)]];
//        return nil;
//    }
    
    FRCreateEventInviteCellViewModel* modelForCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypeInvite inSection:0]];
    
    if (![modelForCell isKindOfClass:[FRCreateEventInviteCellViewModel class]]) {
        modelForCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypeCreateEventAction inSection:0]];
    }
    
    event.isFeatured = modelForCell.featuredMode == FRCreateEventIvntiteTypeCancelFeaured;
    
    
//    if (event.title.length && event.info.length) {
//        return event;
//    } else {
//      return nil;
//    }
    
    return event;
    
}

- (NSString*)_verifyField:(FREventDomainModel*)event
{
    NSMutableString* message = [NSMutableString string];
    if (!event.placeImage)
    {
        [message insertString:@"Image, " atIndex:message.length];
    }
    if (!event.title.length)
    {
        [message insertString:@" Title," atIndex:message.length];
    }
    if (!event.info.length)
    {
        [message insertString:@" Description," atIndex:message.length];
    }
    if (!event.slots)
    {
        [message insertString:@"Slots, " atIndex:message.length];
    }
    if (!event.category.length)
    {
        [message insertString:@"Category, " atIndex:message.length];
    }
    if (!event.date_.length)
    {
        [message insertString:@"Date, " atIndex:message.length];
    }
    if (!event.locationName.length)
    {
        [message insertString:@"Location, " atIndex:message.length];
    }
    if (!event.time_.length)
    {
        [message insertString:@"Time, " atIndex:message.length];
    }
    if ([event.event_start isEqual:@"0"])
    {
        [message insertString:@"Selected wrong time, " atIndex:message.length];
    }
//    if ([FRDateManager isDateEarlierThanToday:event.event_start])
//    {
//        [message insertString:@"Selected wrong date, " atIndex:message.length];
//    }
//    
//    if ((self.isEdit)&&(![message isEqual: @""]))
//    {
//        [self.delegate emptyEventField:message];
//    }
    NSDictionary* userInfo = [NSDictionary new];
    if ([message isEqual: @""])
    {
        userInfo = @{@"isAvailable": @"1"};
    }
    else
    {
        userInfo = @{@"isAvailable": @"0"};
    }
      [[NSNotificationCenter defaultCenter] postNotificationName:@"canCreateEvent" object:nil userInfo:userInfo];
    return message;
}


@end
