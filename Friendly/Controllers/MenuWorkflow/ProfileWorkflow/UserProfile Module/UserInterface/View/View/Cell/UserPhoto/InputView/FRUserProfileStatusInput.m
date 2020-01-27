//
//  FRMyProfileStatusInput.m
//  Friendly
//
//  Created by Sergey Borichev on 13.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileStatusInput.h"
#import "FRUserProfileStatusInputView.h"
#import "FRSettingsTransport.h"

@interface FRUserProfileStatusInput () <FRUserProfileStatusInputViewDelegate>

@property (nonatomic, strong) FRUserProfileStatusInputView* inputView;
@property (nonatomic, strong) NSString* status;

@end

@implementation FRUserProfileStatusInput

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.heightFooter = 233;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputView = [FRUserProfileStatusInputView new];
    
    if (self.heightFooter == 185)
    {
        [_inputView updateButtons];
    }
    
    [self.footerView addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    
    _inputView.delegate = self;
}


#pragma mark - FRMyProfileStatusInputViewDelegate

- (void)selectedStatus:(NSString*)status
{
    if ([status isEqualToString:@"Cancel"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
    self.status = status;
    NSString* str = [NSString new];
        if ([status isEqualToString:@"Block user"])
        {
            str = @"block";
        }
        else if ([status isEqualToString:@"Report user"])
        {
            str = @"report";
        }
        else
        {
            str = @"remove";
        }

    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Warning"
                                                      message:[NSString stringWithFormat:@"Are you sure you want to %@ this user?", str]
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.delegate selectedStatus:self.status userId:self.userId];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)close
{
    [self closeVC];
}


@end


