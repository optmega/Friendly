//
//  FRMyProfileStatusInput.h
//  Friendly
//
//  Created by Sergey Borichev on 13.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRUserProfileStatusInputDelegate <NSObject>

- (void)selectedStatus:(NSString*)status userId:(NSString*)userId;

@end

@interface FRUserProfileStatusInput : FRVCWithOpacity

@property (nonatomic, weak) id<FRUserProfileStatusInputDelegate> delegate;
@property (nonatomic, strong) NSString* userId;

@end
