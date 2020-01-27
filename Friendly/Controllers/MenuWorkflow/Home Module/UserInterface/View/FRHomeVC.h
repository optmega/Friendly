//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeViewInterface.h"
#import "FRHomeModuleInterface.h"
#import "FRBaseVC.h"

@interface FRHomeVC : FRBaseVC <FRHomeViewInterface>

@property (nonatomic, strong) id<FRHomeModuleInterface> eventHandler;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL willShowEventPreview;

- (void)startTimer;
@end
