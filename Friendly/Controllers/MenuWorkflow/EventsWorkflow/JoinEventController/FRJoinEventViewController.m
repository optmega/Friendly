//
//  JoinEventViewController.m
//  Friendly
//
//  Created by Jane Doe on 3/24/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRJoinEventViewController.h"
#import "FRStyleKit.h"
#import "FRProfileTextViewCell.h"
#import "FREventTransport.h"
#import "UIImageView+WebCache.h"
#import "FRAnimator.h"

@interface FRJoinEventViewController() <UITextViewDelegate>

@property (strong, nonatomic) UIImageView* photo;
@property (strong, nonatomic) FREvent* event;
@property (strong, nonatomic) UIButton* closeButton;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* subtitleLabel;
@property (strong, nonatomic) UITextView* messageField;
@property (strong, nonatomic) UIButton* sendRequestButton;
@property (strong, nonatomic) UILabel* maxRangeLabel;
@property (strong, nonatomic) NSString* eventId;
@property BOOL isSelected;
@property long countCharacter;
@property (strong, nonatomic) UIImageView* iconImage;

@end


@implementation FRJoinEventViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self subtitleLabel];
    [self iconImage];
    [self messageField];
    [self titleLabel];
    [self closeButton];
    [self.closeButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self photo];
    [self sendRequestButton];
    [self.sendRequestButton addTarget:self action:@selector(sendingRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self maxRangeLabel];
   
  //    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@284.5);
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [FRAnimator animateConstraint:self.bottom newOffset:0 key:@"bottom" delay:0 bouncingRate:0];
        
    } completion:^(BOOL finished)
     {
         
     }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [APP_DELEGATE sendToGAScreen:@"JoinEventScreen"];
    
    [FRAnimator animateConstraint:self.heightConstraint newOffset:60 key:@"heightConstraint" delay:0.2 bouncingRate:15 completion:nil];
      [FRAnimator animateConstraint:self.iconHeightConstraint newOffset:22 key:@"heightConstraint" delay:0.2 bouncingRate:15 completion:^{
          [self.messageField becomeFirstResponder];
      }];
//    [self.messageField becomeFirstResponder];


}

- (void)closeVC
{
    
    [FRAnimator animateConstraint:self.bottom newOffset:self.heightFooter key:@"bottom"];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished)
     {
         [self.messageField resignFirstResponder];
     }];
    
}

#pragma mark - Actions

-(void)updateWithEventId:(NSString*)eventId
{
    self.eventId = eventId;
}

-(void)updateWithEvent:(FREvent*)event
{
    self.event = event;
    self.eventId = [event eventId];
    
}

- (void) sendingRequest:(UIButton*)sender
{
    if (!self.isSelected)
    {
        if ([self.messageField.text isEqualToString:@""]||[self.messageField.text isEqualToString:@"Message to the host..."])
        {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                    @"Warning" message:@"You should leave a message"  delegate:self
                                                   cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [self.messageField resignFirstResponder];
        
            [UIView animateWithDuration:0.3 animations:^{
                self.messageField.alpha = 0;
                self.maxRangeLabel.alpha = 0;
                self.closeButton.alpha = 0;
            }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.7 delay:0.2 options:0 animations:^{
                                   
//                                     self.view.backgroundColor = [[UIColor bs_colorWithHexString:@"256420"] colorWithAlphaComponent:0.5];
                                     [self.sendRequestButton setTitle:@"Request sent" forState:UIControlStateNormal];
                                     [self.titleLabel setText:[NSString stringWithFormat:@"Request sent to %@", self.event.creator.firstName]];
                                     [self.subtitleLabel setText:@"You will receive a notification if the\nhost has accepted your request"];
                                     [self.sendRequestButton setImage:[FRStyleKit imageOfAttendeeCheckmarkCanvasWhite] forState:UIControlStateNormal];
                                    [self.footerView setFrame:CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y+130, self.footerView.frame.size.width, self.footerView.frame.size.height)];
                                     [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
                                         make.bottom.equalTo(self.view).offset(+130);
                                     }];
//                                     [self.photo setFrame:CGRectMake(self.photo.frame.origin.x, self.photo.frame.origin.y+80, self.photo.frame.size.width, self.photo.frame.size.height)];
//                                     [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y+80, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
//                                     [self.subtitleLabel setFrame:CGRectMake(self.subtitleLabel.frame.origin.x, self.subtitleLabel.frame.origin.y+80, self.subtitleLabel.frame.size.width, self.subtitleLabel.frame.size.height)];
//                                     
//                                     [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
//                                         make.top.equalTo(self.footerView).offset(50);
//                                     }];
                                     
                                 } completion:^(BOOL finished)
                                  {
                                      @weakify(self);
                                      [FREventTransport joinEventWithId:self.eventId message:self.messageField.text success:^{

                                          @strongify(self);
                                          self.event.requestStatus = @(FREventRequestStatusPending);
                                          [self.event.managedObjectContext MR_saveToPersistentStoreAndWait];
                                          [self.delegate updateRequestStatus];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateStatusRequest" object:nil];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              [self closeVC];
                                          });
                                      }
                                                                failure:^(NSError *error) {
                                                                    //
                                                                }];
                                  }];
                         
                             }];
            self.isSelected = YES;
        }
    }
//    else
//    {
//        if (self.event != nil)
//        {
////            self.event.requestStatus = @(FREventRequestStatusPending);
////            [self.delegate reloadData];
//        }
//        else
//        {
//            
//        }
//        [self closeVC];
//    }  
}


#pragma mark - TextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Explain why you interested..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Explain why you interested...";
        textView.textColor = [UIColor bs_colorWithHexString:@"C7C7CD"];
    }
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

    [self.footerView setFrame:CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y-keyboardBounds.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height)];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
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
    [self.footerView setFrame:CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y-keyboardBounds.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height)];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardBounds.size.height);
    }];

    [UIView animateWithDuration:durationAnimation animations:^{
        [self.view layoutIfNeeded];
    }];

 
}

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200)
    {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
       
    return;
    }
     self.countCharacter = 200 - textView.text.length;
     self.maxRangeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.countCharacter];
}

- (BOOL) textViewShouldReturn:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}


#pragma mark - LazyLoad

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setText:[NSString stringWithFormat:@"Join %@'s event", self.event.creator.firstName]];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(20);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.footerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.footerView);
            make.top.equalTo(self.footerView).offset(35);
            make.height.equalTo(@21);
        }];
    }
    return _titleLabel;
}

- (UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:FRLocalizedString(@"The host must approve your request first so\n leave a nice little message", nil)];

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attributedString.length)];
        _subtitleLabel.attributedText = attributedString;
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 15;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _subtitleLabel.text.length)];
//        
        
//        _subtitleLabel.attributedText = attributedString;
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"A2A6B0"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(15);
        [self.footerView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.centerX.equalTo(self.footerView);
        }];
    }
    return _subtitleLabel;
}

- (UITextView*) messageField
{
    if (!_messageField)
    {
        _messageField = [UITextView new];
        _messageField.layer.borderColor = [UIColor bs_colorWithHexString:@"DCE0E8"].CGColor;
        _messageField.layer.borderWidth = 1;
        _messageField.layer.cornerRadius = 7;
        _messageField.delegate = self;

        _messageField.autocorrectionType = UITextAutocorrectionTypeYes;
        _messageField.textContainerInset = UIEdgeInsetsMake(7, 10, 0, 0);
        _messageField.textContainer.lineFragmentPadding = 0;
        _messageField.text = @"Explain why you interested...";
        _messageField.textColor = [UIColor bs_colorWithHexString:@"C7C7CD"];
        _messageField.font = FONT_SF_DISPLAY_REGULAR(16);
        [self.footerView addSubview:_messageField];
        [_messageField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.lessThanOrEqualTo(@65);
            make.left.equalTo(self.footerView).offset(15);
            make.right.equalTo(self.footerView).offset(-15);
            make.top.equalTo(self.subtitleLabel.mas_bottom).offset(20);
            make.bottom.equalTo(self.sendRequestButton.mas_top).offset(-15);
        }];
    }
    return _messageField;
}

- (UILabel*)maxRangeLabel
{
    if (!_maxRangeLabel)
    {
        _maxRangeLabel = [UILabel new];
        _maxRangeLabel.textColor = [UIColor bs_colorWithHexString:kFriendlyBlueColor];
        _maxRangeLabel.font = FONT_SF_TEXT_REGULAR(13);
        _maxRangeLabel.text = @"200";
        
        [self.footerView insertSubview:_maxRangeLabel aboveSubview:self.messageField];
        
        [_maxRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageField).offset(-10);
            make.bottom.equalTo(self.messageField).offset(-10);
        }];
    }
    return _maxRangeLabel;
}

- (UIButton*) sendRequestButton
{
    if (!_sendRequestButton)
    {
        _sendRequestButton = [UIButton new];
        [_sendRequestButton setTitle:@"Send request" forState:UIControlStateNormal];
        [_sendRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendRequestButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [self.footerView addSubview:_sendRequestButton];
        [_sendRequestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.footerView);
            make.height.equalTo(@50);
        }];
    }
    return _sendRequestButton;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        UIImage *image = [FRStyleKit imageOfNavCloseCanvas];
        [_closeButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_closeButton.imageView setTintColor:[UIColor bs_colorWithHexString:@"#BCC0CB"]];
        [self.footerView addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.footerView).offset(15);
            make.height.width.equalTo(@20);
        }];
    }
    return _closeButton;
}

- (UIImageView*) photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
        NSURL* url = [NSURL URLWithString:self.event.creator.userPhoto];
        [_photo sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                _photo.image = image;
            }
        }];

//        _photo.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        _photo.layer.cornerRadius = 30;
        _photo.layer.borderWidth = 4;
        _photo.layer.borderColor = [UIColor whiteColor].CGColor;
        _photo.clipsToBounds = YES;
        [self.footerView addSubview:_photo];
        
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            self.heightConstraint = make.height.equalTo(@0);//70
            make.width.equalTo(_photo.mas_height);
//            make.height.width.equalTo(@60);
            make.top.equalTo(self.footerView.mas_top).offset(-30);
            make.centerX.equalTo(self.footerView);
        }];
    }
    return _photo;
}

- (UIImageView*) iconImage
{
    if (!_iconImage)
    {
        _iconImage = [UIImageView new];
        [_iconImage setImage:[FRStyleKit imageOfGroup4Canvas3]];
        [self.footerView addSubview:_iconImage];
        [self.footerView insertSubview:_iconImage aboveSubview:self.photo];
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            self.iconHeightConstraint = make.height.equalTo(@0);//70
            make.width.equalTo(_iconImage.mas_height);

            make.centerX.equalTo(self.photo.mas_right).offset(-5);
            make.top.equalTo(self.photo.mas_top);
//            make.height.width.equalTo(@22);
        }];
    }
    return _iconImage;
}

@end
