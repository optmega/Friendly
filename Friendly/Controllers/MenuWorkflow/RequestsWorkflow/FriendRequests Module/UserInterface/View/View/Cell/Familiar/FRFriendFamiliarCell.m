//
//  FRFriendFamiliarCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendFamiliarCell.h"
#import "FRSettingsTransport.h"

@interface FRFriendFamiliarCell ()

@property (nonatomic, strong) FRFriendFamiliarCellViewModel* model;

@end

@implementation FRFriendFamiliarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.acceptButton setTitle:FRLocalizedString(@"Add", nil) forState:UIControlStateNormal];
        [self.declineButton setTitle:FRLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
        
        [self.acceptButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllTouchEvents];
        
        [self.declineButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllTouchEvents];
        
        [[self.acceptButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.model selectedAdd];
        }];
        
        [[self.declineButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.model selectedRemove];
        }];
        
    }
    return self;
}

- (void)showUserProfile
{
    UserEntity* user = [FRSettingsTransport getUserWithId:self.model.userId success:^(UserEntity *userProfile, NSArray *mutualFriends)
    {
        UserEntity* e = [FRSettingsTransport getUserWithId:self.model.userId success:nil failure:nil];
        [self.model showUserProfileWithEntity:e];
    } failure:^(NSError *error) {
        //
    }];
    if (user)
    {
        [self.model showUserProfileWithEntity:user];
    }

}

- (void)updateWithModel:(FRFriendFamiliarCellViewModel*)model
{
    self.model = model;
    
    [self.model updatePhotoImage:self.photoImage];
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.statusImage.hidden = true;//!model.isBusy;
    self.statusBackView.hidden = true;
    
}

@end
