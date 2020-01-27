//
//  FRInstagramPhotoPreviewController.m
//  Friendly
//
//  Created by User on 30.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInstagramPhotoPreviewController.h"

@interface FRInstagramPhotoPreviewController ()

@property (strong, nonatomic) UIButton* closePreviewButton;
@property (strong, nonatomic) UIImageView* previewView;
@property (strong, nonatomic) UIView* closeBackView;
@property (strong, nonatomic) UIImage* backImage;

@end

@implementation FRInstagramPhotoPreviewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self closeBackView];
    [self previewView];
    [self closePreviewButton];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateWithPhoto:(UIImage*)image
{
    self.backImage = image;
}

-(UIImageView*) previewView
{
    if (!_previewView)
    {
        _previewView = [UIImageView new];
        [_previewView setBackgroundColor:[UIColor clearColor]];
        _previewView.layer.cornerRadius = 7;
        _previewView.contentMode = UIViewContentModeScaleAspectFill;
        _previewView.clipsToBounds = YES;
        _previewView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        [_previewView addGestureRecognizer:tap];
        [_previewView setImage:self.backImage];
        [self.closeBackView addSubview:_previewView];
        [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-40);
            make.height.equalTo(@295);
            make.width.equalTo(@340);
        }];
    }
    return _previewView;
}


-(UIButton*) closePreviewButton
{
    if (!_closePreviewButton)
    {
        _closePreviewButton = [UIButton new];
        [_closePreviewButton setTitle:@"Close" forState:UIControlStateNormal];
        _closePreviewButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(16);
        [_closePreviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closePreviewButton setBackgroundColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [_closePreviewButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        _closePreviewButton.layer.cornerRadius = 6;
        [self.closeBackView addSubview:_closePreviewButton];
        [_closePreviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.previewView.mas_bottom).offset(10);
            make.centerX.equalTo(self.previewView.mas_centerX);
            make.width.equalTo(@115);
            make.height.equalTo(@40);
        }];
    }
    return _closePreviewButton;
}

-(UIView*)closeBackView
{
    if (!_closeBackView)
    {
        _closeBackView = [UIView new];
        [_closeBackView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [_closeBackView addGestureRecognizer:tap];
        [self.view addSubview:_closeBackView];
        
        [_closeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _closeBackView;
}

@end

