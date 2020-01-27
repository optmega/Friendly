//
//  FRCreateEventGenderViewController.m
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventGenderViewController.h"
#import "FRCreateEventBaseInpute.h"
#import "FRStyleKit.h"
#import "FRGenderInputeView.h"

@interface FRCreateEventGenderViewController () <FRGenderInputeViewDelegate>

@property (nonatomic, strong) FRGenderInputeView* genderView;

@end

static CGFloat const kHeight = 240;

@implementation FRCreateEventGenderViewController

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
    self.genderView = [FRGenderInputeView new];
    [self.genderView setGender:self.genderType];
    
    [self.view addSubview:self.genderView];
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    self.genderView.delegate = self;
    
}


#pragma mark - FRGenderInputeViewDelegate

- (void)selectedGender:(FRGenderType)gender
{
    [self.delegate selectedGender:gender];
    [self closeSelected];
}

- (void)closeSelected
{
    [self closeVC];
}




@end
