//
//  FRCreateEventOpenSlotsViewController.m
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventOpenSlotsViewController.h"
#import "FRCreateEventBaseInpute.h"
#import "FRCreateEventOpenSlotsInputVeiw.h"

@interface FRCreateEventOpenSlotsViewController() <FRCreateEventOpenSlotsInputVeiwDelegate>

@end

static CGFloat const kHeight = 200;

@implementation FRCreateEventOpenSlotsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightFooter = kHeight;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FRCreateEventOpenSlotsInputVeiw* openSlots = [FRCreateEventOpenSlotsInputVeiw new];
    openSlots.delegate = self;
    [openSlots updateUpperValue:self.slotsCount];
    [self.footerView addSubview:openSlots];
    
    [openSlots mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}

#pragma mark - FRCreateEventOpenSlotsInputVeiwDelegate

- (void)slotsUpdate:(NSInteger)slots
{
    [self.delegate slotsUpdate:slots];
    [self closeSelected];
}

- (void)closeSelected
{
    [self closeVC];
}

@end
