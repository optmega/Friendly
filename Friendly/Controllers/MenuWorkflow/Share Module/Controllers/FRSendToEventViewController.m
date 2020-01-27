//
//  FRSendToEventViewController.m
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSendToEventViewController.h"
#import "FRShareTableViewCellWithIcon.h"
#import "FRStyleKit.h"
#import "FRShareEventCell.h"
#import "FREventsCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageHelper.h"
#import <MessageUI/MessageUI.h>

@import AddressBookUI;

@interface FRSendToEventViewController() <UITableViewDataSource, UITableViewDelegate, FRShareTableViewCellWithIconDelegate, MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) NSString* user;

@end

@implementation FRSendToEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    [self.titleLabel setText:@"Send to"];
    [self.closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:kPurpleColor]] forState:UIControlStateNormal];
    self.eventLinkButton.hidden = YES;
    self.user = @"";
}


#pragma mark - DelegateMethods

-(void)showSendMessageVC
{
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        NSArray *recipents = [NSArray new];
        if (self.user!=nil)
        {
        recipents = [NSArray arrayWithObject:self.user];
        }
        NSString *message = [NSString stringWithFormat:@""];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        if (self.user!=nil)
        {
            [messageController setRecipients:recipents];
        }
        [messageController setBody:message];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
        switch (result) {
            case MessageComposeResultCancelled:
                break;
                
            case MessageComposeResultFailed:
            {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                break;
            }
                
            case MessageComposeResultSent:
                break;
                
            default:
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showSelectPeopleVC
{
    ABPeoplePickerNavigationController *personPicker = [ABPeoplePickerNavigationController new];
    personPicker.peoplePickerDelegate = self;
    [self presentViewController:personPicker animated:YES completion:nil];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    NSString *retrievedName;
    NSString *firstName;
    NSString *middleName;
    NSString *lastName;
    NSDate *retrievedDate;
    UIImage *retrievedImage;
    
    // get the first name
    firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    //get the middle name
    middleName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    
    // get the last name
    lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // get the birthday
    retrievedDate = (__bridge_transfer NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
    
    // get personPicture
    if (person != nil && ABPersonHasImageData(person))
    {
        retrievedImage = [UIImage imageWithData:(__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
    }
    else
    {
        retrievedImage = nil;
    }
    
    //set the name
    if (firstName != NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@ %@",firstName,middleName,lastName];
    }
    
    if (firstName != NULL && middleName != NULL & lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName, middleName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",firstName,lastName];
    }
    
    if (firstName != NULL && middleName == NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",firstName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@ %@",middleName, lastName];
    }
    
    if (firstName == NULL && middleName != NULL && lastName == NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@",middleName];
    }
    
    if (firstName == NULL && middleName == NULL && lastName != NULL)
    {
        retrievedName = [[NSString alloc] initWithFormat:@"%@", lastName];
    }
    ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phoneID = ABMultiValueCopyValueAtIndex(phone, 0);
    self.user = (__bridge NSString *)phoneID;
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 190;
    }
    else
    {
        return 101;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    static NSString *CellIdentifier;
    static NSString* CellEventIdentifier;
    CellIdentifier = @"IconCell";
    CellEventIdentifier = @"EventCell";
    FRShareTableViewCellWithIcon *shareIconCell = (FRShareTableViewCellWithIcon*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FRShareEventCell* eventCell = (FRShareEventCell*)[tableView dequeueReusableCellWithIdentifier:CellEventIdentifier];
    
    if (indexPath.row == 0)
    {
        if (!eventCell)
        {
            eventCell = [[FRShareEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellEventIdentifier];
        }
        FREventsCellViewModel* eventModel = [FREventsCellViewModel initWithEvent:self.model];
        [eventCell updateWithModel:eventModel];
        returnCell = eventCell;
    }
    else
    {
        if (!shareIconCell)
        {
            shareIconCell = [[FRShareTableViewCellWithIcon alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 1)
        {
            [shareIconCell updateWithHeader:@"SEND TO PHONE CONTACTS" cellText:@"Select people" andIcon:[FRStyleKit imageOfActionBarEditEventCanvas]];
        }
        if (indexPath.row == 2)
        {
            [shareIconCell updateWithHeader:@"SEND A MESSAGE" cellText:@"Message" andIcon:[FRStyleKit
                                                                                           imageOfActionBarGroupChatCanvas]];
        }
        shareIconCell.delegate = self;
        returnCell = shareIconCell;
    }
    
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
