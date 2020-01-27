//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileDataSource.h"
#import "BSMemoryStorage.h"
#import "FREditProfileUserPhotoCellViewModel.h"
#import "FRUserModel.h"
#import "FRProfileTextViewCellViewModel.h"
#import "FRPrivateAccountCellViewModel.h"
#import "FRProfileShareInstagramCellViewModel.h"
#import "FRProfileDomainModel.h"
#import "FREditProfileViewConstants.h"
#import "FRInterestsModel.h"
#import "Interest.h"

@interface FREditProfileDataSource ()<FREditProfileUserPhotoCellViewModelDelegate>

@end

static NSInteger const kMaxRangeCharacter = 200;

@implementation FREditProfileDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorageWithUserModel:(UserEntity*)user
{
    [self.delegate updateWallImageUrl:user.wallPhoto];
    
    FREditProfileUserPhotoCellViewModel* userPhotoModel = [FREditProfileUserPhotoCellViewModel initWithModel:user];
    userPhotoModel.editDelegate = self;
//    userPhotoModel.wallImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.coverImage]]];
    [self.storage addItem:userPhotoModel];
    
    FRProfileTextViewCellViewModel* job = [FRProfileTextViewCellViewModel new];
    job.title = @"JOB TITLE";
    job.subtitle = @"Not required but a nice touch";
    job.dataString = user.jobTitle;
    job.maxCountCharacter = 70;
    [self.storage addItem:job];
    
    FRProfileTextViewCellViewModel* yourBio = [FRProfileTextViewCellViewModel new];
    yourBio.title = @"YOUR BIO";
    yourBio.subtitle = @"Tell the users about yourself";
    yourBio.dataString = user.yourBio;
    yourBio.isRequiredField = YES;
    yourBio.maxCountCharacter = 200;
    yourBio.countCharacter = kMaxRangeCharacter - user.yourBio.length;
    [self.storage addItem:yourBio];

    FRProfileTextViewCellViewModel* whyAreYouHere = [FRProfileTextViewCellViewModel new];
    whyAreYouHere.title = @"WHY ARE YOU HERE?";
    whyAreYouHere.subtitle = @"Who you would like to meet etc";
    whyAreYouHere.dataString = user.whyAreYouHere;
    whyAreYouHere.isRequiredField = YES;
    whyAreYouHere.maxCountCharacter = 200;
    whyAreYouHere.countCharacter = kMaxRangeCharacter - user.whyAreYouHere.length;
    [self.storage addItem:whyAreYouHere];

    FRProfileTextViewCellViewModel* mobileNumber = [FRProfileTextViewCellViewModel new];
    mobileNumber.title = @"MOBILE NUMBER";
    mobileNumber.subtitle = @"Only visible to users attending your event";
    mobileNumber.dataString = user.mobileNumber;
    mobileNumber.keyType = FRProfileTextViewKeyTypeNumber;
    mobileNumber.isHideMode = true;
    [self.storage addItem:mobileNumber];

    
    FRProfileTextViewCellViewModel* interestsModel = [FRProfileTextViewCellViewModel new];
    interestsModel.title = @"INTERESTS";
    interestsModel.subtitle = @"Interests";
    interestsModel.isInterestCell = YES;
    interestsModel.maxCountCharacter = NSIntegerMax;
//    interestsModel.isHideMode = true;
    NSMutableString* interes = [NSMutableString string];
    
    [user.interests enumerateObjectsUsingBlock:^(Interest * _Nonnull obj, BOOL * _Nonnull stop) {
        [interes insertString:[NSString stringWithFormat:@"%@, ",obj.title] atIndex:interes.length];
    }];
    
//    [user.interests.allObjects enumerateObjectsUsingBlock:^(Interest*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [interes insertString:[NSString stringWithFormat:@"%@, ",obj.title] atIndex:interes.length];
//    }];
    
    interestsModel.dataString = interes.length ? [interes substringWithRange:NSMakeRange(0, interes.length - 2)] : @"";
    [self.storage addItem:interestsModel];
    
    FRPrivateAccountCellViewModel* privateModel = [FRPrivateAccountCellViewModel new];
//    privateModel.title = @"Private account";
//    privateModel.subtitle = @"Hidden images & only friends can message";
//    privateModel.isPrivateAccount = [user.privateAccount boolValue];
    [self.storage addItem:privateModel];

    FRProfileShareInstagramCellViewModel* sharedInstagramModel = [FRProfileShareInstagramCellViewModel new];
    sharedInstagramModel.title = FRLocalizedString(@"Share instagram photos", nil);
    sharedInstagramModel.subtitle = FRLocalizedString(@"Creates a gallery on you profile", nil);
    [self.storage addItem:sharedInstagramModel];
    
}

- (void)updateUserPhoto:(UIImage*)photo
{
    FREditProfileUserPhotoCellViewModel* userPhotoModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeUserPhoto inSection:0]];
    userPhotoModel.userPhotoImage = photo;
    [FRUserManager sharedInstance].currentUserPhoto = photo;
    [self.storage reloadItem:userPhotoModel];
}

- (void)updateWallPhoto:(UIImage*)wallPhoto
{
    [self.delegate updateWallImage:wallPhoto];
    
    FREditProfileUserPhotoCellViewModel* userPhotoModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeUserPhoto inSection:0]];
    userPhotoModel.wallImage = wallPhoto;
    [self.storage reloadItem:userPhotoModel];
}


- (FRProfileDomainModel*)profile
{
    FRProfileDomainModel* userProfile = [FRProfileDomainModel new];
    
    
    FREditProfileUserPhotoCellViewModel* userPhotoModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeUserPhoto inSection:0]];
    userProfile.wallImage = userPhotoModel.wallImage;
    userProfile.photoImage = userPhotoModel.userPhotoImage;
    
    FRProfileTextViewCellViewModel* job = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeJobTitle inSection:0]];;
    userProfile.job_title = [job.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRProfileTextViewCellViewModel* yourBio = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeYourBio inSection:0]];;
    userProfile.your_bio = [yourBio.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRProfileTextViewCellViewModel* whyAreYouHere = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeWhyAreYouHere inSection:0]];;
    userProfile.why_are_you_here = [whyAreYouHere.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRProfileTextViewCellViewModel* mobileNumber = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeMobileNumber inSection:0]];
    
     FRProfileTextViewCellViewModel* interestsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypeInterests inSection:0]];
    userProfile.interests = [interestsModel.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    userProfile.mobile_number = [mobileNumber.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRPrivateAccountCellViewModel* privateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREditProfileCellTypePrivateAccount inSection:0]];;
//    userProfile.private_account = privateModel.isPrivateAccount;
    
    NSString* emptyField = [self _verifyField:userProfile];
    if (emptyField.length)
    {
        [self.delegate emptyEventField:[emptyField substringWithRange:NSMakeRange(0, emptyField.length - 2)]];
        return nil;
    }
    
//    userProfile.email = ;
    
    return userProfile;
}


#pragma mark - FREditProfileUserPhotoCellViewModelDelegate

- (void)changeUserPhoto
{
    [self.delegate changeUserPhoto];
}

- (void)changeWallPhoto
{
    [self.delegate changeWallPhoto];
}

- (void)saveSelected
{
    [self.delegate saveSelected];
}

- (void)settingSelected
{
    [self.delegate settingSelected];
}


#pragma mark - Private

- (NSString*)_verifyField:(FRProfileDomainModel*)profile
{

    NSInteger count = [self verifyInterests:profile.interests];
    NSMutableString* message = [NSMutableString string];
    if (!profile.your_bio.length)
    {
        [message insertString:@"Your bio, " atIndex:message.length];
    }
    if (!profile.why_are_you_here.length)
    {
        [message insertString:@"Why are you here, " atIndex:message.length];
    }
//    if (!profile.interests.length)
    if ((count <2)||(([[profile.interests substringFromIndex: [profile.interests length] - 1] isEqualToString:@","])&&(count == 2)))
    {
        [message insertString:@"Interests, " atIndex:message.length];
    }
    if (profile.mobile_number.length > 0 && profile.mobile_number.length < 14)
    {
        [message insertString:@"Mobile number (is invalid), " atIndex:message.length];
    }
    return message;
}

- (NSUInteger)verifyInterests:(NSString*)interestsString
{
    NSUInteger count = 0, length = [interestsString length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [interestsString rangeOfString: @"," options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return count;
}


@end
