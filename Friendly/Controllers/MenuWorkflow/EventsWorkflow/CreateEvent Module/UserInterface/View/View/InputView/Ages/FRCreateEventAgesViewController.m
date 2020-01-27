//
//  FRCreateEventAgesViewController.m
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventAgesViewController.h"
#import "NMRangeSlider.h"
#import "FRCreateEventBaseInpute.h"
#import "FRInputViewAges.h"
#import "BSHudHelper.h"

@interface FRCreateEventAgesViewController() <FRInputViewAgesDelegate>

@property (nonatomic, strong) FRInputViewAges* agesInputView;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;

@end

static CGFloat const kHeight = 200;

@implementation FRCreateEventAgesViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightFooter = kHeight;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.agesInputView = [FRInputViewAges new];
    [self.footerView addSubview:_agesInputView];
    
    [self.agesInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    self.agesInputView.delegate = self;
    [self.agesInputView setAgeMin:self.min max:self.max];
}


- (void)setAgeMin:(CGFloat)min max:(CGFloat)max
{
    self.min = min;
    self.max = max;
}

- (FRInputViewAges*)agesInputView
{
    if (!_agesInputView)
    {
        _agesInputView = [FRInputViewAges new];
    }
    return _agesInputView;
}

#pragma mark - FRInputViewAgesDelegate

- (void)updateAgesMin:(NSInteger)min max:(NSInteger)max
{
    [self.delegate updateAgesMin:min max:max];
    [self closeVC];
}

- (void)selectedWrongRange
{
    [BSHudHelper showHudWithType:BSHudTypeError view:self title:FRLocalizedString(@"Selected wrong range", nil) message:FRLocalizedString(@"Please select minimum 5 year gap.", nil)];
}

- (void)closeSelected
{
    [self closeVC];
}


@end
