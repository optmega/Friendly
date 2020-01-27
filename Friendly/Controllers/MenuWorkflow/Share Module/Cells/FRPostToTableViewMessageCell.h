//
//  FRPostToTableViewMessageCell.h
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRPostToTableViewMessageCellDelegate <NSObject>

-(void)scrollView;
-(void)scrollViewBack;
-(void)changeMessage:(NSString*)text;

@end

@interface FRPostToTableViewMessageCell : UITableViewCell

-(void)updateMessageViewWithText:(NSString*)message;
@property (weak, nonatomic) NSObject<FRPostToTableViewMessageCellDelegate>* delegate;
@property (strong, nonatomic) UITextView* messageView;

@end
