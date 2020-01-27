//
//  FREventCollectionCellFooter.h
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREventCollectionCellFooterViewModel;

@interface FREventCollectionCellFooter : UIView

@property (nonatomic, strong) UIButton* joinButton;

- (void)updateWithModel:(FREventCollectionCellFooterViewModel*)model;

@end
