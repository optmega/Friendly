//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileController.h"
#import "FREditProfileDataSource.h"
#import "FREditProfileViewConstants.h"

#import "FREditProfileUserPhotoCell.h"
#import "FRProfileTextViewCell.h"
#import "FRPrivateAccountCell.h"
#import "FRMyProfileShareInstagramCell.h"

@interface FREditProfileController () <FRProfileTextViewCellDelegate>
@property (nonatomic, strong) UITextView *currentTextView;
@end

@implementation FREditProfileController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FREditProfileUserPhotoCell class] forModelClass:[FREditProfileUserPhotoCellViewModel class]];
        [self registerCellClass:[FRProfileTextViewCell class] forModelClass:[FRProfileTextViewCellViewModel class]];
        [self registerCellClass:[FRPrivateAccountCell class] forModelClass:[FRPrivateAccountCellViewModel class]];
        [self registerCellClass:[FRMyProfileShareInstagramCell class] forModelClass:[FRProfileShareInstagramCellViewModel class]];

    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.currentTextView resignFirstResponder];
    self.currentTextView = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDataSource:(FREditProfileDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[FRProfileTextViewCell class]])
    {
        FRProfileTextViewCell* textFieldCell = (FRProfileTextViewCell*)cell;
        textFieldCell.delegate = self;
    }
    
}

//- (void)textEditing:(UITableViewCell*)cell :(UITextView *)textView
//{
//    self.currentTextView = textView;
//    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    });
//}
//
//- (void)textChangeWithCell:(UITableViewCell *)cell
//{
//    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//    [self.tableView beginUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    [self.tableView endUpdates];
//}


- (void)textEditing:(UITableViewCell*)cell :(UITextView *)textView
{
    self.currentTextView = textView;
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        //    CGPoint point = self.tableView.contentOffset;
        //    point.y -= 50;
        
        
        //        self.tableView.contentOffset = point;
        
    });
    
    
}

- (void)textChangeWithCell:(UITableViewCell *)cell
{
    [self.tableView beginUpdates];
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    FRProfileTextViewCellViewModel* model = [storage itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case FREditProfileCellTypeUserPhoto:
        {
            return 270;
        } break;
        case FREditProfileCellTypeJobTitle:
        {
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case FREditProfileCellTypeYourBio:
        {
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case FREditProfileCellTypeWhyAreYouHere:
        {
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case FREditProfileCellTypeMobileNumber:
        {
            //https://tecsynt.plan.io/issues/1526 - нужно выпилить интересы и номер
//            return [(FRProfileTextViewCellViewModel*)model cellHeight];
            return 0;
        } break;
        case FREditProfileCellTypeInterests:
        {
            //https://tecsynt.plan.io/issues/1526 - нужно выпилить интересы и номер
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
//            return 0;
        } break;
            
        case FREditProfileCellTypePrivateAccount:
        {
            return 0;
//            return 90;
        } break;
            
        case FREditProfileCellTypeShareInstagram:
        {
            FRProfileShareInstagramCellViewModel* model =[storage itemAtIndexPath:indexPath];
            return model.heightCell; //100
        } break;
            
        default:
            return self.tableView.rowHeight;
            break;
    }
            
}
    
    
    

    
    
@end
