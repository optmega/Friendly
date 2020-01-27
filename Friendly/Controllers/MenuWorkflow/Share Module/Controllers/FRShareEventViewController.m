 //
//  FRShareEventViewController.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRShareEventViewController.h"
#import "FRShareTableViewCellWithIcon.h"
#import "FRStyleKit.h"
#import "FRShareEventCell.h"
#import "FREventsCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRSendToEventViewController.h"
#import "FRPostToEventViewController.h"
#import "FRMessengerViewController.h"
#import "FREvent.h"
#import "FRDateManager.h"
#import <MessageUI/MessageUI.h>
#import "FRBaseVC.h"
#import "BSHudHelper.h"


@import AddressBookUI;

@interface FRShareEventViewController () <UITableViewDataSource, UITableViewDelegate, FRShareTableViewCellWithIconDelegate, FRPostToEventViewControllerDelegate, MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) NSString* user;
//@property (strong, nonatomic) NSMutableArray* cellsArray;
@end

@implementation FRShareEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self tableView];
    [self separator];
    [self overleyNavBar];
    [self eventLinkButton];
    [self backButton];
    [self.titleLabel setText:@"Share event"];
    self.toolbar.hidden = YES;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [APP_DELEGATE sendToGAScreen:@"ShareEventScreen"];
}

-(void)updateWithEvent:(FREvent*)event
{
    self.model = event;
}

-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    message = [NSString stringWithFormat:@"%@ (%u Spots left) - %@", self.model.title, [self.model.slots intValue]-self.model.memberUsers.count, self.model.info];

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
        [self dismissViewControllerAnimated:NO completion:^(){
            [self showSendMessageVC];
        }];
}

-(void)copyEventLink
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@%@",EVENT, self.model.eventId];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Success!", nil) message:FRLocalizedString(@"Link has been copied", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
              
    }];
    
    [alertController addAction:accept];
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
    return 210;
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
        NSString* dayOfWeek = [[FRDateManager dayOfWeek:[eventModel domainModel].event_start] uppercaseString];
        NSString* day =  [[FRDateManager dayOfMonth:[eventModel domainModel].event_start] uppercaseString];
        [eventCell.dateView updateWithDay:day andDayOfWeek:dayOfWeek];

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
        [shareIconCell updateWithHeader:@"SEND TO A SOCIAL PROFILE" cellText:@"Post to your wall"
                                andIcon:[FRStyleKit imageOfFeildFacebookCanvasGray]];
        }
        if (indexPath.row == 2)
        {
        [shareIconCell updateWithHeader:@"SEND A MESSAGE" cellText:@"Text it to a friend" andIcon:[FRStyleKit
        imageOfSendToCanvas]];
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

- (void)showSendToVC
{
    [self showSelectPeopleVC];
//    FRSendToEventViewController* sendToVC = [FRSendToEventViewController new];
//    [sendToVC updateWithEvent:self.model];
//    [self presentViewController:sendToVC animated:YES completion:nil];
//    FRMessengerViewController* messVC = [FRMessengerViewController new];
//    [self presentViewController:messVC animated:YES completion:nil];
}

-(void)showPostToVC
{
    FRPostToEventViewController* postToVC = [FRPostToEventViewController new];
    postToVC.eventId = self.model.eventId;
    [postToVC updateWithEvent:self.model];
    postToVC.delegate = self;
    [self presentViewController:postToVC animated:YES completion:nil];
}


#pragma mark - LazyLoad

-(UITableView*) tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.equalTo(@415);
        }];

    }
    return _tableView;
}

-(UIButton*) eventLinkButton
{
    if (!_eventLinkButton)
    {
        _eventLinkButton = [UIButton new];
        [_eventLinkButton setBackgroundColor:[UIColor whiteColor]];
        [_eventLinkButton setTitle:@"Copy event link" forState:UIControlStateNormal];
        [_eventLinkButton setTitleColor:[[UIColor bs_colorWithHexString:@"263345"] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_eventLinkButton addTarget:self action:@selector(copyEventLink) forControlEvents:UIControlEventTouchUpInside];
        [_eventLinkButton setTitleColor:[UIColor bs_colorWithHexString:@"263345"] forState:UIControlStateNormal];
        [_eventLinkButton.titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(17)];
        [self.view addSubview:_eventLinkButton];
        [_eventLinkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableView).offset(15);
            make.right.equalTo(self.tableView).offset(-15);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@60.5);
        }];
    }
    return _eventLinkButton;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.eventLinkButton addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.eventLinkButton);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UIButton*) backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        [_backButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        _backButton.layer.cornerRadius = 17.5;
        _backButton.layer.zPosition = 5;
        [_backButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        _backButton.layer.masksToBounds = NO;
        
        [self.view addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(25);
            make.width.height.equalTo(@35);
            make.left.equalTo(self.view).offset(15);
        }];
        [self.backButton bringSubviewToFront:self.overleyNavBar];
    }
    return _backButton;
}

- (UIImageView*)overleyNavBar
{
    if (!_overleyNavBar)
    {
        _overleyNavBar = [UIImageView new];
        _overleyNavBar.image = [UIImage imageNamed:@"Offline Copy"];
        _overleyNavBar.layer.zPosition += 1;
        [self.view addSubview:_overleyNavBar];
        [_overleyNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
    }
    return _overleyNavBar;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}


@end
