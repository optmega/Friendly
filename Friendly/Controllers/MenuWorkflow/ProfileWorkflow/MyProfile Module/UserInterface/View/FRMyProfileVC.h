//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileViewInterface.h"
#import "FRMyProfileModuleInterface.h"
#import "FRBaseVC.h"

@interface FRMyProfileVC : FRBaseVC <FRMyProfileViewInterface>

@property (nonatomic, strong) id<FRMyProfileModuleInterface> eventHandler;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* backButton;

@property (nonatomic, assign) BOOL canUpdate;

@end
