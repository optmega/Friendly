//
//  FRSearchByCategoryMarkerView.h
//  Friendly
//
//  Created by User on 17.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventModel.h"

@protocol FRSearchByCategoryMarkerViewDelegate <NSObject>

- (void)showEventPreviewWithEvent:(FREvent*)event;
- (void)showUserProfile:(UserEntity*)user;

@end

@interface FRSearchByCategoryMarkerView : UIView

@property (strong, nonatomic) UIImageView* userAvatarView;
//@property (strong, nonatomic) UIButton* arrowButton;
@property (strong, nonatomic) UILabel* titleLabel;
@property (weak, nonatomic) id<FRSearchByCategoryMarkerViewDelegate> delegate;

-(void)updateWithModel:(FREvent*)model;

@end
