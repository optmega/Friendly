//
//  FRMyEventsSegmentedMenu.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsSegmentedMenu.h"
#import "FRMyEventsSegmentedMenuButton.h"

@interface FRMyEventsSegmentedMenu()

@property (strong, nonatomic) FRMyEventsSegmentedMenuButton* hostingButton;
@property (strong, nonatomic) FRMyEventsSegmentedMenuButton* joiningButton;
@property (nonatomic, strong) UIView* firstSelectedSeparator;
@property (nonatomic, strong) UIView* secondSelectedSeparator;
@property (nonatomic, strong) UIView* sliderView;

@end

@implementation FRMyEventsSegmentedMenu


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self firstSelectedSeparator];
        [self secondSelectedSeparator];
        [self hostingButton];
        [self joiningButton];

        [self.hostingButton addTarget:self action:@selector(selectedFirstAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.joiningButton addTarget:self action:@selector(selectedSecondAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.joiningButton setTitleColor:[UIColor bs_colorWithHexString:@"#97A1BE"] forState:UIControlStateNormal];
        self.secondSelectedSeparator.hidden = YES;
        self.firstSelectedSeparator.hidden = NO;
        
        
        self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(15, 37, [UIScreen mainScreen].bounds.size.width / 2 - 20, 3)];
        self.sliderView.layer.cornerRadius = 1.5;
        self.sliderView.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self addSubview:self.sliderView];
    }
    return self;
}

- (void)selectedFirstAction:(UIButton*)sender
{
    self.joiningButton.titleLabel.textColor = [UIColor bs_colorWithHexString:@"#97A1BE"];
    self.hostingButton.titleLabel.textColor = [UIColor blackColor];
//    self.firstSelectedSeparator.hidden = NO;
    self.secondSelectedSeparator.hidden = YES;
    [self.delegate selectedHosting];
    
    [self bringSubviewToFront:self.sliderView];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.hostingButton.frame;
        frame.origin.y = frame.size.height - 3;
        frame.size.height = 3;
        self.sliderView.frame = frame;
        self.sliderView.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
    }];
}

- (void)selectedSecondAction:(UIButton*)sender
{
    self.hostingButton.titleLabel.textColor = [UIColor bs_colorWithHexString:@"#97A1BE"];
    [self.joiningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.firstSelectedSeparator.hidden = YES;
//    self.secondSelectedSeparator.hidden = NO;
    [self.delegate selectedJoining];
    

    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.joiningButton.frame;
        frame.origin.y = frame.size.height - 3;
        frame.size.height = 3;
        
        self.sliderView.frame = frame;
        self.sliderView.backgroundColor = [UIColor bs_colorWithHexString:@"33ABFF"];
    }];
}


- (FRMyEventsSegmentedMenuButton *) hostingButton
{
    if (!_hostingButton)
    {
        _hostingButton= [FRMyEventsSegmentedMenuButton new];
        [_hostingButton setTitle:@"Hosting" forState:UIControlStateNormal];
        _hostingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //   _featuredButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [self addSubview:_hostingButton];
        [_hostingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self.mas_centerX).offset(-5);
            make.top.bottom.equalTo(self);
        //    make.width.equalTo(@90);
        }];
    }
    return _hostingButton;
}

- (FRMyEventsSegmentedMenuButton*) joiningButton
{
    if (!_joiningButton)
    {
        _joiningButton= [FRMyEventsSegmentedMenuButton new];
        [_joiningButton setTitle:@"Attending" forState:UIControlStateNormal];
        _joiningButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:_joiningButton];
        [_joiningButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self.mas_centerX).offset(5);
            make.top.bottom.equalTo(self);
          //  make.width.equalTo(@90);
        }];
    }
    return _joiningButton;
}

- (UIView*) firstSelectedSeparator
{
    if(!_firstSelectedSeparator)
    {
        _firstSelectedSeparator = [UIView new];
        _firstSelectedSeparator.layer.cornerRadius = 5;
        _firstSelectedSeparator.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        _firstSelectedSeparator.clipsToBounds = YES;

        [self.hostingButton addSubview:_firstSelectedSeparator];
        
        [_firstSelectedSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.hostingButton);
            make.height.equalTo(@3);
        }];
        
    }
    return _firstSelectedSeparator;
}

- (UIView*) secondSelectedSeparator
{
    if(!_secondSelectedSeparator)
    {
        _secondSelectedSeparator = [UIView new];
        _secondSelectedSeparator.layer.cornerRadius = 5;
        _secondSelectedSeparator.clipsToBounds = YES;
        _secondSelectedSeparator.backgroundColor = [UIColor bs_colorWithHexString:@"#33ABFF"];
        [self.joiningButton addSubview:_secondSelectedSeparator];
        [_secondSelectedSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.joiningButton);
            make.height.equalTo(@3);
        }];
        
    }
    return _secondSelectedSeparator;
}

@end
