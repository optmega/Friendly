//
//  FRMyProfileStatusInputView.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventBaseInpute.h"

@protocol FRMyProfileStatusInputViewDelegate <NSObject>

- (void)selectedStatus:(NSString*)status;
- (void)close;


@end

@interface FRMyProfileStatusInputView : FRCreateEventBaseInpute

@property (nonatomic, weak) id<FRMyProfileStatusInputViewDelegate> delegate;

@end
