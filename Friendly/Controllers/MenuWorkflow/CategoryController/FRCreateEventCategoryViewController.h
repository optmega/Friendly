//
//  FRAddEventCategoryViewController.h
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRCreateEventCategoryDelegate <NSObject>

- (void)selectedCategory:(NSString*)category andId:(NSString*)id;

@end

@interface FRCreateEventCategoryViewController : UIViewController

@property (weak, nonatomic) id<FRCreateEventCategoryDelegate>delegate;

@end
