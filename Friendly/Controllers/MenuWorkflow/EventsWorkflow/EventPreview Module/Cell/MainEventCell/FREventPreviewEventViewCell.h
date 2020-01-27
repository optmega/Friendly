//
//  HomeCollectionViewCell.h
//  Project
//
//  Created by Jane Doe on 2/29/16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventPreviewEventViewCellViewModel.h"
#import "FREventModel.h"
#import "FREventPreviewDownView.h"

//@protocol BackHomeDelegate;

@protocol FREventPreviewEventViewCellDelegate <NSObject>

-(void)showJoinRequest;
-(void)showUserProfile:(NSString*)userId;
-(void)showPartnerProfile;

@end

@interface FREventPreviewEventViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* headerView;
@property (strong, nonatomic) UIButton* joinButton;
@property (nonatomic, strong) UIView* frontground;
@property (weak, nonatomic) NSObject<FREventPreviewEventViewCellDelegate>* delegate;
@property (strong, nonatomic) UIView* downView;
@property (strong, nonatomic) UIImageView* overlayImage;


- (void) updateWithModel:(FREventPreviewEventViewCellViewModel*)model;
- (void) updateEventImage:(UIImage*)eventImage;

- (void)hideAllSubviews;

@end

