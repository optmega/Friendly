//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishController.h"
#import "FRProfilePolishDataSource.h"

#import "FRPrivateAccountCell.h"
#import "FRProfileTextViewCell.h"
#import "FRProfileShareInstagramCell.h"
#import "FRProfilePolishHeaderCell.h"

@interface FRProfilePolishController () <FRProfileTextViewCellDelegate>
@property (nonatomic, strong) UITextView *currentTextView;
@end

@implementation FRProfilePolishController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRPrivateAccountCell class] forModelClass:[FRPrivateAccountCellViewModel class]];
        
        [self registerCellClass:[FRProfileTextViewCell class] forModelClass:[FRProfileTextViewCellViewModel class]];
        
        [self registerCellClass:[FRProfileShareInstagramCell class] forModelClass:[FRProfileShareInstagramCellViewModel class]];
        [self registerCellClass:[FRProfilePolishHeaderCell class] forModelClass:[FRProfilePolishHeaderCellViewModel class]];


    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[FRProfileTextViewCell class]])
    {
        FRProfileTextViewCell* textFieldCell = (FRProfileTextViewCell*)cell;
        textFieldCell.delegate = self;
    }
    
}


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
    [self.tableView endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    FRProfileTextViewCellViewModel* model = [storage itemAtIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
        {
            return  300;
        }
        case 1:
        {
//            return 91.;
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case 2:
        {
//            return 120.5;
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case 3:
        {
//            return 120.5;
            return [(FRProfileTextViewCellViewModel*)model cellHeight];
        } break;
        case 4:
        {
//            return 91;
            return [(FRProfileTextViewCellViewModel*)model cellHeight];

        } break;
//        case 5:
//        {
//            return 0;
////            return 91;
//        } break;
        case 5:
        {
            if ([FRUserManager sharedInstance].currentUser.instagram_id!=0) {
                return 0;
            }
            else
            {
                return 120.5;
            }
        } break;
            
        default:
            return self.tableView.rowHeight;
            break;
    }
}

- (void)updateDataSource:(FRProfilePolishDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (void)hideKeyboard
{
    [self.currentTextView resignFirstResponder];
    self.currentTextView = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyboard" object:nil];
}

@end
