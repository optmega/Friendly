//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishDataSource.h"
#import "BSMemoryStorage.h"
#import "FRStyleKit.h"
#import "FRPrivateAccountCellViewModel.h"
#import "FRProfileTextViewCellViewModel.h"
#import "FRProfileShareInstagramCellViewModel.h"
#import "FRProfileDomainModel.h"
#import "FRProfilePolishHeaderCellViewModel.h"
#import "FRUserManager.h"
#import "FRSocialTransport.h"

@interface FRProfilePolishDataSource ()
<
    FRProfileShareInstagramCellViewModelDelegate,
    FRProfilePolishHeaderCellViewModelDelegate
>

@end
@implementation FRProfilePolishDataSource


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage
{
    FRProfilePolishHeaderCellViewModel* headerModel = [FRProfilePolishHeaderCellViewModel new];
    headerModel.delegate = self;
    if ([FRUserManager sharedInstance].userModel.photo)
    {
        headerModel.photoUrl = [FRUserManager sharedInstance].userModel.photo;
    }
    else
    {
        headerModel.photo = [FRStyleKit imageOfDefaultAvatar];
    }
    [self.storage addItem:headerModel];
    
    FRProfileTextViewCellViewModel* job = [FRProfileTextViewCellViewModel new];
    job.title = @"JOB TITLE";
    job.maxCountCharacter = 70;
    job.subtitle = @"Not required but a nice touch";
    
    FRProfileTextViewCellViewModel* yourBio = [FRProfileTextViewCellViewModel new];
    yourBio.title = @"YOUR BIO";
    yourBio.subtitle = @"Tell the users about yourself";
    yourBio.isRequiredField = YES;
    yourBio.countCharacter = 200;
    
    FRProfileTextViewCellViewModel* whyAreYouHere = [FRProfileTextViewCellViewModel new];
    whyAreYouHere.title = @"WHY ARE YOU HERE?";
    whyAreYouHere.subtitle = @"Who you would like to meet etc";
    whyAreYouHere.isRequiredField = YES;
    whyAreYouHere.countCharacter = 200;

    
    FRProfileTextViewCellViewModel* mobileNumber = [FRProfileTextViewCellViewModel new];
    mobileNumber.title = @"MOBILE NUMBER";
    mobileNumber.subtitle = @"Only visible to users attending your event";
    mobileNumber.keyType = FRProfileTextViewKeyTypeNumber;
    
//    FRPrivateAccountCellViewModel* privateModel = [FRPrivateAccountCellViewModel new];
//    privateModel.title = @"Private account";
//    privateModel.subtitle = @"Hidden images & only friends can message";
    
    FRProfileShareInstagramCellViewModel* sharedInstagramModel = [FRProfileShareInstagramCellViewModel new];
    sharedInstagramModel.title = @"Share instagram photos";
    sharedInstagramModel.subtitle = @"Creates a gallery on you profile";
    sharedInstagramModel.delegate = self;
    
    [self.storage addItems:@[job, yourBio, whyAreYouHere, mobileNumber, sharedInstagramModel]];
    
}


- (FRProfileDomainModel*)profile
{
    FRProfileDomainModel* userProfile = [FRProfileDomainModel new];
    
    
    FRProfilePolishHeaderCellViewModel* headerModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    userProfile.photoImage = headerModel.photo;
    
    FRProfileTextViewCellViewModel* job = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];;
    userProfile.job_title = [job.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRProfileTextViewCellViewModel* yourBio = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];;
    userProfile.your_bio = [yourBio.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FRProfileTextViewCellViewModel* whyAreYouHere = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];;
    userProfile.why_are_you_here = [whyAreYouHere.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    FRProfileTextViewCellViewModel* mobileNumber = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];;
    userProfile.mobile_number = [mobileNumber.dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    FRPrivateAccountCellViewModel* privateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];;
//    userProfile.private_account = privateModel.isPrivateAccount;
    
    NSString* emptyField = [self _verifyField:userProfile];
    if (emptyField.length)
    {
        [self.delegate emptyEventField:[emptyField substringWithRange:NSMakeRange(0, emptyField.length - 2)]];
        return nil;
    }
//    userProfile.email = @"mail@mail.ua";
    return userProfile;
}


#pragma mark - FRProfilePolishHeaderCellViewModelDelegate

- (void)selectedChangePhoto
{
    [self.delegate selectedChangePhoto];
}

- (void)selectedBack
{
    [self.delegate backSelected];
}



#pragma mark - FRProfileShareInstagramCellViewModelDelegate

- (void)connectSelected
{
    [self.delegate selectedConnectInstagram];
}

- (void)updateUserPhoto:(UIImage*)image
{
    FRProfilePolishHeaderCellViewModel* headerModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    headerModel.photo = image;
    [self.storage reloadItem:headerModel];
}

#pragma mark - Private

- (NSString*)_verifyField:(FRProfileDomainModel*)profile
{
    NSMutableString* message = [NSMutableString string];
    if (!profile.your_bio.length)
    {
        [message insertString:@"Your bio, " atIndex:message.length];
    }
    if (!profile.why_are_you_here.length)
    {
        [message insertString:@"Why are you here, " atIndex:message.length];
    }
    if (profile.mobile_number.length > 0 && profile.mobile_number.length < 14)
    {
        [message insertString:@"Mobile number (is invalid), " atIndex:message.length];
    }
    return message;
}

- (void)showPreviewWithImage:(UIImage *)image {
    
}

@end
