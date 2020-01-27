//
//  FRCreateEventInviteCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteCellViewModel.h"
#import "FREventModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"

@implementation FRCreateEventInviteCellViewModel

//-(CGFloat)heightCell
//{
//    if (self.isForEditing)
//    {
//        return 295;
//    }
//    else
//    {
//        return 245; //245
//    }
//}

-(void)deleteEvent
{
    [self.delegate deleteEvent];
}

- (void)selectedInvite {
    [self.delegate pressInvite];
}
- (void)selectedFeature {
    [self.delegate pressFeature:self];
}

- (void)updatePhoto:(UIImageView*)photo {
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.fetureModel.invited_last.photo]];
    [photo sd_setImageWithURL:url placeholderImage:[FRUserManager sharedInstance].logoImage];
}

- (NSAttributedString*)inviteTitle {
    NSString* text = [NSString stringWithFormat:@"%@ joined %@ ago.", self.fetureModel.invited_last.first_name, [FRDateManager dateForChatRoomFromDate:[FRDateManager dateFromServerWithString:self.fetureModel.invited_last.created_at]]];
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attString addAttribute:NSFontAttributeName
                      value:FONT_SF_DISPLAY_BOLD(12)
                      range:NSMakeRange(0, self.fetureModel.invited_last.first_name.length)];
    
    return  attString;
}
@end
