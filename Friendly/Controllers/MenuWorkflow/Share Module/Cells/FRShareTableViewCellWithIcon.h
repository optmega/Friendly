//
//  FRShareTableViewCellWithIcon.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRShareTableViewCellWithIconDelegate <NSObject>

-(void)showSendToVC;
-(void)showPostToVC;
-(void)showSelectPeopleVC;
-(void)showSendMessageVC;

@end

@interface FRShareTableViewCellWithIcon : UITableViewCell

-(void)updateWithHeader:(NSString*)headerText cellText:(NSString*)cellText andIcon:(UIImage*)icon;
@property (weak, nonatomic) NSObject<FRShareTableViewCellWithIconDelegate>* delegate;

@end
