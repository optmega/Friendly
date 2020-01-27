//
//  FRCreateEventInviteToCoHostViewController.m
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteToCoHostViewController.h"
#import "FRFriendsTransport.h"
#import "FRStyleKit.h"
#import "FRFriendsListModel.h"
#import "FRCreateEventInviteFriendsCollectionCell.h"
#import "BSHudHelper.h"

@interface FRCreateEventInviteToCoHostViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FRInviteFriendsCollectionCellDelegate, UITextFieldDelegate>

@property (assign, nonatomic) BOOL isSomethingChecked;
@property (strong, nonatomic) NSString* partnerId;
@property (strong, nonatomic) NSString* partnerName;
@property (strong, nonatomic) NSNumber* page;
@property (strong, nonatomic) NSMutableArray* arrayToShow;
@property (assign, nonatomic) int pageCount;

@end

@implementation FRCreateEventInviteToCoHostViewController


- (void) viewDidLoad
{
//    [super viewDidLoad];
    [self inviteFriendsView];
    self.counter = 0;
    self.page = @1;
    [self titleLabel];
    if (self.eventId == nil) {
        self.eventId = @"0";
    }
    [self getCandidatesData];

    self.friendsArray = [NSMutableArray array];
    self.arrayToShow = [NSMutableArray array];
    [self.searchView.searchField addTarget:self
                                    action:@selector(textFieldDidChange)
                          forControlEvents:UIControlEventEditingChanged];
    [self friendsCollectionView];
    self.searchView.hidden = YES;
    self.searchView.searchField.delegate = self;
//    self.friendsCollectionView.pagingEnabled = YES;
    [self.inviteFriendsView.cancelButton setTitle:@"Done" forState:UIControlStateNormal];
    if (self.isSomethingChecked)
    {
        [self.inviteFriendsView.cancelButton setTitle:@"Confirm partner swap" forState:UIControlStateNormal];
    }
    [self inviteFBButton];
    [self.searchView.closeButton addTarget:self action:@selector(hideSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteFriendsView.closeButton setImage:[FRStyleKit imageOfTabSearchCanvas] forState:UIControlStateNormal];
    [self.inviteFriendsView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteFriendsView.cancelButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeVC)];
    [self.emptyFieldView addGestureRecognizer:tapGest];
}
 
- (void)getCandidatesData
{
    [FRFriendsTransport getCandidatesListWithEvent:self.eventId page:self.page success:^(FRCandidatesListModel *friendsList, NSString* pageCount) {
        [self.friendsArray addObjectsFromArray:friendsList.friends];
        [self.arrayToShow addObjectsFromArray:friendsList.friends];
        self.pageCount = [pageCount intValue];
        [self.friendsCollectionView reloadData];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
}

- (void)closeAction:(UIButton*)sender
{
    if (sender == self.inviteFriendsView.closeButton)
    {
        [self makeFrameSearch];
    }
    else if (sender == self.inviteFriendsView.cancelButton)
    {
        if (![self.partnerId isEqual:@""])
        {
            [self.selectPartnerDelegate selectedPartnerWithId:self.partnerId andName:self.partnerName];
        }
        [self closeVC];
    }
}

- (void) hideSearch:(id)sender
{
    [self.searchView.searchField resignFirstResponder];
    self.titleLabel.hidden = NO;
    self.inviteFBButton.hidden = NO;
    self.searchView.hidden = YES;
}

- (void) makeFrameSearch
{
    self.titleLabel.hidden = YES;
    self.inviteFBButton.hidden = YES;
    self.searchView.hidden = NO;
    [self.searchView.searchField becomeFirstResponder];
}

#pragma mark - TextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [self.inviteFriendsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.item == self.arrayToShow.count - 3)&&([self.page intValue] < self.pageCount))
    {
        int value = [self.page intValue];
        self.page = [NSNumber numberWithInt:value + 1];
        [self getCandidatesData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayToShow.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCreateEventInviteFriendsCollectionCell *cell=(FRCreateEventInviteFriendsCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell updateWithModel:[self.arrayToShow objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCreateEventInviteFriendsCollectionCell* cellSelected =  (FRCreateEventInviteFriendsCollectionCell*)[self.friendsCollectionView cellForItemAtIndexPath:indexPath];
    BOOL isCellChecker = cellSelected.isChecked;
    FRUserModel* user = [self.friendsArray objectAtIndex:indexPath.row];
//    if (self.isSomethingChecked)
//    {
        for (FRCreateEventInviteFriendsCollectionCell *cell in self.friendsCollectionView.visibleCells)
        {
            cell.checkedView.hidden = YES;
            cell.isChecked = NO;
            self.isSomethingChecked = NO;
        }
    cellSelected.isChecked = isCellChecker;
    self.isSomethingChecked = !isCellChecker;
    [cellSelected updateCellWithCheckedView];
    self.partnerId = user.id;
    self.partnerName = user.first_name;
//    }
//    else     
//    {
//        [cell updateCellWithCheckedView];
//        self.isSomethingChecked = YES;
//        self.partnerId = user.id;
//        self.partnerName = user.first_name;
//
//    }
    
       return YES;
}

-(void)textFieldDidChange
{
    NSString* name = self.searchView.searchField.text;
    NSMutableArray * array = [NSMutableArray array];
    for (FRUserModel * object in self.friendsArray) {
        if ([object.first_name containsString:name])
        {
            [array addObject:object];
        }
    }
    self.arrayToShow = array;
    if ([self.searchView.searchField.text isEqualToString:@""])
    {
        self.arrayToShow = self.friendsArray;
    }
    [self.friendsCollectionView reloadData];
}



@end
