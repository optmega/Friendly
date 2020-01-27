//
//  FRMyProfileStatusInput.m
//  Friendly
//
//  Created by Sergey Borichev on 13.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileStatusInput.h"
#import "FRMyProfileStatusInputView.h"

@interface FRMyProfileStatusInput () <FRMyProfileStatusInputViewDelegate>

@property (nonatomic, strong) FRMyProfileStatusInputView* inputView;

@end

@implementation FRMyProfileStatusInput

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightFooter = 295;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputView = [FRMyProfileStatusInputView new];
    
    [self.footerView addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    
    _inputView.delegate = self;

}

#pragma mark - FRMyProfileStatusInputViewDelegate

- (void)selectedStatus:(NSString*)status
{
    [self.delegate selectedStatus:status];
    [self closeVC];
}

- (void)close
{
    [self closeVC];
}


@end





