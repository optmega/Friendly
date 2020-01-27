//
//  FRCreateEventBaseInpute.h
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//



@interface FRCreateEventBaseInpute : UIView

@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIButton* cancelButton;

- (void)closeSelected;

@end
