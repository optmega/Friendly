//
//  FRHomeEvenTableHeader.h
//  Friendly
//
//  Created by Sergey on 20.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventsCellViewModel.h"

@interface FRHomeEventTableHeader: UIView

@property (nonatomic, weak) id<FREventsCellViewModelDelegate> delegate;

- (void)updateWithModels:(NSArray<FREvent*>*)models;
- (void)startTimer;
- (void)stopTimer;
- (void)changePositionY:(CGFloat)positionY;
- (void)updateContent:(FREventsCellViewModel*)viewModel;

@end