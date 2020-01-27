//
//  FRGroupChatNavigationView.h
//  Friendly
//
//  Created by Sergey on 14.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRGroupChatNavigationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftItem;
@property (weak, nonatomic) IBOutlet UIButton *rightItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *centerItem;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end
