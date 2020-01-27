//
//  FRPostToEventViewController.m
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPostToEventViewController.h"
#import "FRStyleKit.h"
#import "FRShareEventCell.h"
#import "FREventsCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRPostTableViewSocialCell.h"
#import "UIImageHelper.h"
#import "FRPostToTableViewMessageCell.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FRDateManager.h"
#import "FRUploadImage.h"
#import "BSHudHelper.h"
#import "FRSettingsTransport.h"

@interface FRPostToEventViewController() <UITableViewDataSource, UITableViewDelegate, FRPostToTableViewMessageCellDelegate, FBSDKSharingDelegate, UITextViewDelegate>

@property (strong, nonatomic) UIButton* postButton;
@property (nonatomic, assign) FBSDKShareDialogMode mode;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) UIImage* eventScreen;
@property (strong, nonatomic) UIImageView* testView;
@property (strong, nonatomic) NSString* uploadImageUrl;

@end

@implementation FRPostToEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.backButton.hidden = YES;
    self.overleyNavBar.hidden = YES;
    [self.titleLabel setText:@"Post to"];
    [self.closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:kPurpleColor]] forState:UIControlStateNormal];
    [self postButton];
  
    self.eventLinkButton.hidden = YES;
    UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:gest];
//    [self testView];
    self.eventScreen = [self screenshot];
//    [self.testView setImage:self.eventScreen];
      [self.backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.backButton.hidden = NO;
    self.overleyNavBar.hidden = NO;

}

- (UIImage *) screenshot {
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rec = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        CGRect cropRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 205);
    image = [UIImageHelper image:image crop:cropRect];
    
    return image;
//    CGRect cropRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
//    // or use the UIImage wherever you like
//    
//    return [UIImage imageWithCGImage:imageRef];
}


-(void)scrollView
{
    [self.tableView beginUpdates];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    CGPoint point = self.tableView.contentOffset;
//    point.y += 148;
//    self.tableView.contentOffset = point;
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView endUpdates];
}

-(void)scrollViewBack
{
    [self.tableView beginUpdates];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //    CGPoint point = self.tableView.contentOffset;
    //    point.y += 148;
    //    self.tableView.contentOffset = point;
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+120, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView endUpdates];

}

#pragma mark - TextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;
    CGFloat durationAnimation;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&durationAnimation];
    
    [self.view setNeedsLayout];
    [self.postButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];
    
    [UIView animateWithDuration:durationAnimation animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;
    CGFloat durationAnimation;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&durationAnimation];
    
    [self.view setNeedsLayout];
    [self.postButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:durationAnimation animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL) textViewShouldReturn:(UITextView *)textField
{
    [self endEditing];
    return YES;
}

-(void)endEditing
{
    [self.view endEditing:YES];
}

-(void)changeMessage:(NSString *)text
{
    self.message = text;
}


-(void)postToFB
{
//    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
//    shareDialog.delegate=self;
//    shareDialog.fromViewController = self;
  
    
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRUploadImage uploadImage:self.eventScreen complite:^(NSString *imageUrl) {
        
        
        
        
        BSDispatchBlockToMainQueue(^{
            
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EVENT, self.eventId]];
            
//            [FRSettingsTransport getInviteUrl:^(NSString *url) {
                [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
                self.uploadImageUrl = imageUrl;
                FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                content.contentTitle = self.model.title;
                content.contentDescription = self.message;
                content.contentURL = url;
                content.imageURL = [NSURL URLWithString:self.uploadImageUrl];
                FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
                dialog.fromViewController = self;
                dialog.delegate = self;
                dialog.shareContent = content;
                dialog.mode = FBSDKShareDialogModeFeedBrowser; // if you don't set this before canShow call, canShow would always return YES
                if (![dialog canShow]) {
                    // fallback presentation when there is no FB app
                    dialog.mode = FBSDKShareDialogModeFeedBrowser;
                }
                [dialog show];

//            } failure:^(NSError *error) {
//                NSLog(@"Error - %@", error.localizedDescription);
//            }];

           
        });
        
       
    } failute:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:nil];

    }];
   //    NSString *iTunesLink = [NSString stringWithFormat:@"friendlyTESTUrl://%@", self.model.id];
//    content.contentURL = [[NSURL alloc] initWithScheme:@"friendlyTESTUrl" host:self.model.id path:@"/"];
//    content.contentURL = [NSURL URLWithString:iTunesLink];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate closeVC];
    }];
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 210;
    }
    else if (indexPath.row == 2)
    {
        return 148;
    }
    else
    {
        return 60;
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
    static NSString* CellMessageIdentifier;
    CellIdentifier = @"PostCell";
    CellMessageIdentifier = @"MessageCell";
    CellEventIdentifier = @"EventCell";
    FRPostTableViewSocialCell *shareIconCell = (FRPostTableViewSocialCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FRShareEventCell* eventCell = (FRShareEventCell*)[tableView dequeueReusableCellWithIdentifier:CellEventIdentifier];
    FRPostToTableViewMessageCell* messageCell = (FRPostToTableViewMessageCell*)[tableView dequeueReusableCellWithIdentifier:CellMessageIdentifier];
    if (indexPath.row == 0)
    {
        if (!eventCell)
        {
            eventCell = [[FRShareEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellEventIdentifier];
        }
        FREventsCellViewModel* eventModel = [FREventsCellViewModel initWithEvent:self.model];
        NSString* dayOfWeek = [[FRDateManager dayOfWeek:[eventModel domainModel].event_start] uppercaseString];
        NSString* day =  [[FRDateManager dayOfMonth:[eventModel domainModel].event_start] uppercaseString];
        [eventCell updateWithModel:eventModel];
        [eventCell.dateView updateWithDay:day andDayOfWeek:dayOfWeek];
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
        [eventCell addGestureRecognizer:gest];
        returnCell = eventCell;
    }
    else if (indexPath.row == 2)
    {
        if (!messageCell)
        {
            messageCell = [[FRPostToTableViewMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellMessageIdentifier];
        }
        self.message = [NSString stringWithFormat:@"%@ (%lu Spots left) - %@", self.model.title, [self.model.slots intValue]-self.model.memberUsers.count, self.model.info];
        [messageCell updateMessageViewWithText:self.message];
        messageCell.delegate = self;
        messageCell.messageView.delegate = self;
        returnCell = messageCell;
    }
    else if (indexPath.row == 1)
    {
        if (!shareIconCell)
        {
            shareIconCell = [[FRPostTableViewSocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
        [shareIconCell addGestureRecognizer:gest];
        returnCell = shareIconCell;
    }
    
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




#pragma mark - LazyLoad

-(UIButton*) postButton
{
    if (!_postButton)
    {
        _postButton = [UIButton new];
        [_postButton setTitle:@"Post" forState:UIControlStateNormal];
        [_postButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton setBackgroundImage:[UIImage imageNamed:@"purpleWithOpacity"] forState:UIControlStateHighlighted];
        [_postButton addTarget:self action:@selector(postToFB) forControlEvents:UIControlEventTouchUpInside];
        [_postButton.titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(16)];
        [self.view addSubview:_postButton];
        [_postButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@60);
        }];
    }
    return _postButton;
}

-(UIImageView*)testView
{
    if (!_testView)
    {
        _testView = [UIImageView new];
        _testView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_testView];
        [_testView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@210);
            make.left.right.bottom.equalTo(self.postButton);
        }];
    }
    return _testView;
}

@end
