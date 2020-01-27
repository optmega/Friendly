//
//  FRMessagerChatPreviewVC.m
//  Friendly
//
//  Created by Sergey on 26.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagerChatPreviewVC.h"
#import "UIImageHelper.h"
#import "FRPrivateChatUserHeader.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"

@interface FRMessagerChatPreviewVC ()

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSString* titleImage;


@end

@implementation FRMessagerChatPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [[UINavigationBar appearance] setTintColor:[UIColor bs_colorWithHexString:@"#939BAF"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:false];
    
    [[UINavigationBar appearance] setShadowImage:[UIImageHelper imageFromColor:[UIColor bs_colorWithHexString:@"E4E6EA"]]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    [self.collectionView registerClass:[FRPrivateChatUserHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"FRPrivateChatUserHeader"];
    
    self.navigationItem.titleView = self.titleView;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor bs_colorWithHexString:@"#939BAF"];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    
    self.navigationController.navigationBarHidden = NO;
    

    UIImage* imageBack = [UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageBack
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backSelected)];
    
    
    
    
    
    
    
    UIImage* imageOptions = [UIImageHelper image:[FRStyleKit imageOfFeildMoreOptionsCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:imageOptions
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(showActionSheet:)];
    
    

    
 
    
}

- (void)showActionSheet:(id)sender {
    
}

- (void)backSelected {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIView*)titleView
{
    if (!_titleView)
    {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        label.font = FONT_SF_DISPLAY_MEDIUM(16);
        [label setText:self.titleString];
        
        [_titleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_titleView);
        }];
        
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedUser)];
        
        [_titleView addGestureRecognizer:gest];
        
        UIImageView* im = [UIImageView new];
        
        [im sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:self.titleImage]]];
        im.clipsToBounds = YES;
        im.contentMode = UIViewContentModeScaleAspectFill;
        im.layer.cornerRadius = 12;
        [_titleView addSubview:im];
        
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(label.mas_left).offset(-3);
            make.width.height.equalTo(@24);
        }];
    }
    return _titleView;
}


- (void)selectedUser {
    
}


@end
