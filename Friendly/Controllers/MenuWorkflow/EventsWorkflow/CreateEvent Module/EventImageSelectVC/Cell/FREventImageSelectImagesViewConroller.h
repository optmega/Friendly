//
//  FREventImageSelectImagesViewConroller.h
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectViewController.h"

@protocol FREventImageSelectImagesViewConrollerCloseDelegate <NSObject>

-(void)closeVC;

@end
@interface FREventImageSelectImagesViewConroller : WhiteHeaderVC

-(void)updateWithImages:(NSArray*)images;

@property (weak, nonatomic) id createPresenter;
//- (instancetype)initWithCategory:(NSString*)category;
@property (weak, nonatomic) id<FREventImageSelectImagesViewConrollerCloseDelegate> closeDelegate;



@end
