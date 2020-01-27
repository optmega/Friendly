//
//  FRHomeEvenTableHeader.m
//  Friendly
//
//  Created by Sergey on 20.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHomeEvenTableHeader.h"
#import "FRHomeEventTableHeaderView.h"
#import "EAIntroView.h"
#import "FREventCollectionCellFooter.h"
#import "FREventsCellViewModel.h"
#import "FREventCollectionCellFooterViewModel.h"
#import "FRStyleKit.h"

#import "UIScrollView+TwitterCover.h"
#import "UIImageView+LBBlurredImage.h"
#import "FREventsCellViewModel.h"
#import "FRDistanceLabel.h"
#import "FRConnetctionManager.h"

@interface FRHomeEventTableHeader ()<EAIntroDelegate>

@property (nonatomic, strong) EAIntroView* pageContentView;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIButton* joinButton;
@property (nonatomic, strong) NSArray* models;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) CGFloat lastPosition;

@property (nonatomic, strong) UIImageView* contentView;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) FRDistanceLabel *awayLabel;
@property (nonatomic, strong) UIImageView* hostingImage;
@property (nonatomic, strong) UIImageView* cohostingImage;

@property (nonatomic, strong) NSArray* views;
@property (nonatomic, assign) CGFloat widthBlack;

@property (nonatomic, strong) FREventCollectionCellFooter* footer;
@property (nonatomic, strong) UIImageView* genderImage;
@property (nonatomic, strong) UIButton* shareButton;

@property (nonatomic, strong) NSArray* events;

@property (nonatomic, assign) CGFloat lastXPosition;
@end

@implementation FRHomeEventTableHeader


- (UIButton*)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton new];
        [_shareButton setImage:[FRStyleKit imageOfActionBarShareCanvas] forState:UIControlStateNormal];
        
        _shareButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _shareButton.layer.cornerRadius = 16;
//        _shareButton.layer.drawsAsynchronously = YES;
        _shareButton.layer.masksToBounds = NO;
        _shareButton.tintColor = [UIColor whiteColor];
        [self addSubview:_shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(20);
            make.height.width.equalTo(@32);
        }];
    }
    
    return _shareButton;
}

- (UIImageView*)genderImage
{
    if (!_genderImage)
    {
        _genderImage = [UIImageView new];
        _genderImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_genderImage];
        [_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.width.equalTo(@100);
            make.height.equalTo(@26);
        }];
    }
    return _genderImage;
}

- (FREventCollectionCellFooter*)footer
{
    if (!_footer)
    {
        _footer = [FREventCollectionCellFooter new];
        _footer.joinButton.hidden = true;
        [self addSubview:_footer];
        [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _footer;
}

- (NSArray*)views {
    if (!_views) {
        
        NSMutableArray* array = [NSMutableArray array];
        
        for (int i = 0; i < 6; i++) {
            
            UIView* separator = [UIView new];
            separator.backgroundColor = [UIColor blackColor];
            separator.hidden = true;
            [self.contentView addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(self.widthBlack));
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                NSLog(@"%f",i * [UIScreen mainScreen].bounds.size.width);                
                make.left.equalTo(self.contentView.mas_right).offset(i * [UIScreen mainScreen].bounds.size.width);
            }];
            
            [array addObject:separator];
        }
        _views = array;
        [self bringSubviewToFront:self.label];
        [self bringSubviewToFront:self.pageContentView.pageControl];
    }
    
    return _views;
}


- (UIImageView*)contentView
{
    if (!_contentView)
    {
        _contentView = [UIImageView new];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-50);
        }];
    }
    return _contentView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
//        _titleLabel.layer.drawsAsynchronously = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        
        [_titleLabel sizeToFit];
        _titleLabel.shadowOffset = CGSizeMake(-1.5, 2);
        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(50);
        
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-30);
        }];
    }
    return _titleLabel;
}

- (FRDistanceLabel*)awayLabel
{
    if (!_awayLabel)
    {
        _awayLabel = [FRDistanceLabel new];
        _awayLabel.font = FONT_SF_DISPLAY_SEMIBOLD(11);
        _awayLabel.textColor = [UIColor whiteColor];
        _awayLabel.backgroundColor = [UIColor bs_colorWithHexString:@"1F1451"];
        _awayLabel.layer.cornerRadius = 4;
        _awayLabel.clipsToBounds = true;
        
        [self.contentView addSubview:_awayLabel];
        [_awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
            make.centerX.equalTo(self.titleLabel);
        }];
    }
    return _awayLabel;
}

- (UIImageView*)hostingImage
{
    if (!_hostingImage)
    {
        _hostingImage = [UIImageView new];
        _hostingImage.userInteractionEnabled = true;
        [_hostingImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostingSelected)]];
        _hostingImage.clipsToBounds = true;
        _hostingImage.layer.cornerRadius = 37.5;
        _hostingImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _hostingImage.layer.borderWidth = 4;
        _hostingImage.image = [FRStyleKit imageOfDefaultAvatar];
        [self.contentView addSubview:_hostingImage];
        [_hostingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@75);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-12);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _hostingImage;
}

- (UIImageView*)cohostingImage
{
    if (!_cohostingImage)
    {
        _cohostingImage = [UIImageView new];
        _cohostingImage.alpha = 0;
        _cohostingImage.userInteractionEnabled = true;
        [_hostingImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cohostingSelected)]];
        _cohostingImage.clipsToBounds = true;
        _cohostingImage.layer.cornerRadius = 37.5;
        _cohostingImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _cohostingImage.layer.borderWidth = 4;
        _cohostingImage.image = [FRStyleKit imageOfDefaultAvatar];
        
        [self.contentView addSubview:_cohostingImage];
        [_cohostingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@75);
            make.top.equalTo(self.hostingImage);
            make.left.equalTo(self.hostingImage.mas_right).offset(-28);
        }];
    }
    return _cohostingImage;
}

- (void)hostingSelected {
    
}

- (void)cohostingSelected {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self pageContentView ];
        self.clipsToBounds = false;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageContentView];
        [self shareButton];
        [self label];
        
        [self footer];
        [self.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
        self.width = [UIScreen mainScreen].bounds.size.width;
        [self cohostingImage];
        [self contentView];
        [self.contentView bringSubviewToFront:self.hostingImage];
        self.widthBlack = [UIScreen mainScreen].bounds.size.width / 13.8;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusRequest) name:@"UpdateStatusRequest" object:nil];
        
//        [self.contentView bringSubviewToFront:_shareButton];
        
        @weakify(self);
        [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate selectedShareEvent:self.events[self.pageContentView.currentPageIndex]];
        }];

        
    }
    
    return self;
}

- (void)updateStatusRequest {
    
    if (!self.pageContentView.pages.count) {
        return;
    }
    
    EAIntroPage* currentPage = [self.pageContentView.pages objectAtIndex:self.pageContentView.currentPageIndex];
    
    FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)currentPage.customView;
    FREventsCellViewModel* viewModel = header.viewModel;
    [self updateContent:viewModel];
}

- (void)joinAction:(UIButton*)sender
{

    if (![FRConnetctionManager isConnected]) {
        return;
    }
    
    [self stopTimer];
    EAIntroPage* currentPage = [self.pageContentView.pages objectAtIndex:self.pageContentView.currentPageIndex];
    FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)currentPage.customView;
    FREventsCellViewModel* viewModel = header.viewModel;
    
    
    if ([sender.titleLabel.text isEqualToString:@"Join"]) // жесть а не проверка
    {
        NSString* gender = [FRUserManager sharedInstance].userModel.gender;
        NSString* genderIntegerValue = [NSString new];
        if ([gender isEqualToString:@"male"])
        {
            genderIntegerValue = @"1";
            gender = @"female";
        }
        else
        {
            genderIntegerValue = @"2";
            gender = @"male";
        }
        if (![viewModel.domainModel.gender.stringValue isEqualToString:@"0"]&![viewModel.domainModel.gender.stringValue isEqualToString:genderIntegerValue])
        {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ops" message:[NSString stringWithFormat:@"Ops it looks like the guest has only opened it to %@s", gender] delegate:self
                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [viewModel joinEventSelected];
        }
    }
    
    [self startTimer];
    
}

- (void)changePositionY:(CGFloat)positionY
{
    if (!self.pageContentView.pages.count)
    {
        return;
    }
    EAIntroPage* page = [self.pageContentView.pages objectAtIndex:self.pageContentView.currentPageIndex];
    FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)page.customView;
    
    if (positionY < 0)
    {
        [self stopTimer];
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(positionY));
        }];
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(positionY + 20);
        }];
        
        header.topConstaint.constant = positionY;
        header.leftConstr.constant =  positionY / 2;
        header.rightConstr.constant = positionY / 2;
        
        header.blurView.alpha = -positionY / 65;

    }
    else
    {
        [self startTimer];
        if (header.topConstaint.constant != 0)
        {
            header.topConstaint.constant = 0;
            header.leftConstr.constant = 0;
            header.rightConstr.constant = 0;

            [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(20);
            }];
            
            [self.contentView bringSubviewToFront:self.shareButton];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
            }];
        }
        header.blurView.alpha = 0;
    }
}

- (UILabel*)label
{
    if (!_label)
    {
        _label = [UILabel new];
        _label.backgroundColor = [UIColor bs_colorWithHexString:@"#F6890A"];
        _label.text = @"FEATURED";
        _label.layer.cornerRadius = 4;
        _label.clipsToBounds = true;
        _label.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@74);
            make.height.equalTo(@21);
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-73);
        }];
        
    }
    return _label;
}

- (UIButton*)joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
//        _joinButton.layer.drawsAsynchronously = YES;
        _joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _joinButton.layer.cornerRadius = 5;
        [self addSubview:_joinButton];
        
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@31);
            make.width.equalTo(@75);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _joinButton;
}



- (void)startTimer
{
//    return;
    
    if (self.pageContentView.pages.count <= 1)
    {
        return;
    }
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                  target:self
                                                selector:@selector(targetMethod:)
                                                userInfo:nil
                                                 repeats:true];
    
    for (UIView* separator in self.views) {
        separator.hidden = true;
    }
}

- (void)stopTimer
{
    for (UIView* separator in self.views) {
        separator.hidden = false;
    }
    
    for (EAIntroPage* page in self.pageContentView.pages) {
        FRHomeEventTableHeaderView* custom =  (FRHomeEventTableHeaderView*)[page customView];
        
        custom.blackSeparator.hidden = true;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

typedef void(^Block)(BOOL hide);

- (void)targetMethod:(id)sender
{
    
    if (!self.pageContentView.pages.count) {
        return;
    }
    
    Block blockMainView = ^(BOOL hide) {
        
        self.cohostingImage.hidden = hide;
        self.hostingImage.hidden = hide;
        self.titleLabel.hidden = hide;
        self.awayLabel.hidden = hide;

    };
    
    Block blockBlackSeparator = ^(BOOL hide) {
      
        for (EAIntroPage* page in self.pageContentView.pages) {
            FRHomeEventTableHeaderView* custom =  (FRHomeEventTableHeaderView*)[page customView];
            
            if ([page isEqual:self.pageContentView.pages.lastObject]) {
                
                custom.blackSeparator.hidden = true;
                continue;
            }
            
            custom.blackSeparator.hidden = hide;
        }
    };
    
    
    CGFloat currentX = self.pageContentView.scrollView.contentOffset.x;
    NSInteger currentPage = currentX / [UIScreen mainScreen].bounds.size.width;
    
    CGFloat newPositionX = [UIScreen mainScreen].bounds.size.width * (currentPage + 1);
    
    
    FRHomeEventTableHeaderView* page =  (FRHomeEventTableHeaderView*)[self.pageContentView.pages[currentPage] customView];
    page.blackSeparator.hidden = false;
    
    
    if (currentPage > self.pageContentView.pages.count - 2) {
        newPositionX = 0;
    }
    
    currentPage += 1;
    if (currentPage > self.pageContentView.pages.count - 1){
        currentPage = 0;
        
        blockMainView(true);
        blockBlackSeparator(false);
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pageContentView.scrollView.contentOffset = CGPointMake(newPositionX, 0);
        [self changeOpacity:0];
    } completion:^(BOOL finished) {
        
        [self changeOpacity:1];
        
        [self intro:self.pageContentView pageEndScrolling:self.pageContentView.pages[currentPage] withIndex:currentPage];
        self.pageContentView.currentPageIndex = currentPage;

        
        if (currentPage == 0) {
            blockMainView(false);
            blockBlackSeparator(true);
        }
        
        page.blackSeparator.hidden = true;
    }];

}

- (void)updateWithModels:(NSArray<FREvent*>*)models
{
    self.events = [models copy];
    NSMutableArray* eventModels = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FREvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.objectID) {
            return;
        }
        
        obj = [[NSManagedObjectContext MR_defaultContext] objectWithID:obj.objectID];
        
        FREventsCellViewModel* model = [FREventsCellViewModel initWithEvent:obj];
        if (idx == 0) {
            [self updateContent:model];
            FREventCollectionCellFooterViewModel* fm = [FREventCollectionCellFooterViewModel initWithModel:model.domainModel];
            [self.footer updateWithModel:fm];
        }
        model.delegate = self.delegate;
        FRHomeEventTableHeaderView* view = [FRHomeEventTableHeaderView new];
        [view updateWithModel:model];
        if (idx == 0) {
            [view updateAlpha:1];
        }
        EAIntroPage* page = [EAIntroPage pageWithCustomView:view];
        [eventModels addObject:page];
    }];
    
    self.pageContentView.pages = eventModels;
    
}

- (void)introDidFinish:(EAIntroView *)introView
{
}
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex
{
    
}
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex
{
    [self stopTimer];
//    [self hideWithShowCOho:false];
}

- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex
{
    FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)page.customView;
    [self updateContent:header.viewModel];

    BOOL showCoho = (header.viewModel.domainModel.partnerHosting != nil)&& header.viewModel.domainModel.partnerIsAccepted.boolValue;
    
    [self updateAlpha:0 showCOho:showCoho];
    [self updateAlpha:1 showCOho:showCoho];
}

- (void)updateContent:(FREventsCellViewModel*)viewModel {
    self.titleLabel.text =  viewModel.domainModel.title;
    self.awayLabel.text = viewModel.distance;
    [viewModel updateUserPhoto:self.hostingImage];
    [viewModel updatePartnerPhoto:self.cohostingImage];
    [self.footer updateWithModel:[FREventCollectionCellFooterViewModel initWithModel:viewModel.domainModel]];
    
    [self _setEventRequestStatusType: [[[viewModel domainModel] requestStatus] integerValue]];
    
    [self _setGender:viewModel.domainModel.gender.integerValue];
    BOOL showCoho = (viewModel.domainModel.partnerHosting != nil)&& viewModel.domainModel.partnerIsAccepted.boolValue;
    if (showCoho)
    {
        [self.hostingImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(-20);
        }];
        self.cohostingImage.alpha = 1;
    }
    else
    {
        [self.hostingImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        self.cohostingImage.alpha = 0;
    }
    
    [self.hostingImage bringSubviewToFront:self];

}

- (void)hideWithShowCOho:(BOOL)showCo {
    
     CGFloat alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (showCo) {
            self.cohostingImage.alpha = alpha;
        } else {
            self.cohostingImage.alpha = 0;
        }
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.hostingImage.alpha = alpha;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                self.titleLabel.alpha = alpha;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.awayLabel.alpha = alpha;
                    self.footer.alpha = alpha;
                    self.genderImage.alpha = alpha;
                } completion:^(BOOL finished) {
                    
                }];
                
                [UIView animateWithDuration:0.05 animations:^{
//                    self.footer.alpha = alpha;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];

}

- (void)changeOpacity:(CGFloat)opasity {
 
    if (self.cohostingImage.alpha) {
        
        self.cohostingImage.alpha = opasity;
    } else {
        self.cohostingImage.alpha = 0;
    }
    self.hostingImage.alpha = opasity * 2;
    self.titleLabel.alpha = opasity * 2;
    self.awayLabel.alpha = opasity * 2;
    self.footer.alpha = opasity / 2;
    self.genderImage.alpha = opasity / 2;
}

- (void)updateAlpha:(CGFloat)alpha showCOho:(BOOL)showCo {
    
    [UIView animateWithDuration:0.5 animations:^{
        if (showCo) {
            self.cohostingImage.alpha = alpha;
        } else {
            self.cohostingImage.alpha = 0;
        }
        
        self.hostingImage.alpha = alpha;
        self.titleLabel.alpha = alpha;
        self.awayLabel.alpha = alpha;
        self.footer.alpha = alpha;
        self.genderImage.alpha = alpha;
    }];

    
    return;
    
 }

- (void)_setGender:(FRGenderType)gender
{
    switch (gender) {
        case FRGenderTypeAll: {
            self.genderImage.image = [FRStyleKit imageOfSexBoth];
            break;
        }
        case FRGenderTypeMale: {
            self.genderImage.image = [FRStyleKit imageOfSexMaleOnCanvas];
            
            break;
        }
        case FRGenderTypeFemale: {
            self.genderImage.image = [FRStyleKit imageOfSexFemaleOnCanvas];
            
            break;
        }
    }
    
    [self.genderImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.genderImage.image.size.width / 2));
    }];
}

- (void)_setEventRequestStatusType:(FREventRequestStatusType)eventRequestStatusType
{
    switch (eventRequestStatusType){
        case FREventRequestStatusAvailableToJoin:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
            [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusPending:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Pending" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusAccepted:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
            [self.joinButton setTitle:@"Attending" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } break;
            
        case FREventRequestStatusDeclined:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
            [self.joinButton setTitle:@"Declined" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case FREventRequestStatusUnsubscribe:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } break;
            case FREventRequestStatusDiscard:
        {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"Discard" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        } break;
            
        default: {
            self.joinButton.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
            [self.joinButton setTitle:@"NoState" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            
    }
}


- (void)scroll:(CGFloat)positionX
{
    if (!self.pageContentView.pages.count) {
        return;
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    
    NSInteger page =  positionX / screenWidth;
    CGFloat currentX = 1.0f - ((positionX - screenWidth * page) / screenWidth) * 1.4f;
    
    
    if (positionX > self.lastXPosition) {
        
        if (currentX != 1.0f) {
            [self changeOpacity:currentX];
        }
        
    } else  if (currentX != 1.0f) {
        
        
        if (currentX < 0) {
            [self changeOpacity:-currentX];
        } else {
            [self changeOpacity:0];
        }
    }
    
    self.lastXPosition = positionX;
    
    
    
 
    if (page < self.pageContentView.pages.count - 1) {
        
         FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)((EAIntroPage*)[self.pageContentView.pages objectAtIndex:page]).customView;
        
        CGRect frame = header.eventImage.frame ;
        frame.origin.x = (positionX - page* [UIScreen mainScreen].bounds.size.width) / 2;
        header.eventImage.frame = frame;

    }
    
    
    if (positionX <= 0) {
       FRHomeEventTableHeaderView* header = (FRHomeEventTableHeaderView*)((EAIntroPage*)[self.pageContentView.pages objectAtIndex:0]).customView;
        [self updateContent:header.viewModel];
    }
    
    
    [self.views enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.origin.x = ((idx + 1) * [UIScreen mainScreen].bounds.size.width - positionX * 1.07 +
                          (self.widthBlack * idx) - 1 * idx);
        obj.frame = frame;
    }];
    
    
    NSLog(@"%f", positionX);
    if (positionX == screenWidth* self.pageContentView.pages.count - screenWidth  || positionX == 0) {
        
        BSDispatchBlockAfter(.6, ^{
            
            [self changeOpacity:2];
        });
    }

}


- (EAIntroView*)pageContentView
{
    if (!_pageContentView)
    {
        UIView* view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        
        EAIntroPage* page = [EAIntroPage pageWithCustomView:view];
        
        UIView* view1= [UIView new];
        view1.backgroundColor = [UIColor redColor];
        
        page.customView = view1;
        
        _pageContentView = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400) andPages:@[]];
        _pageContentView.backgroundColor = [UIColor clearColor];
        _pageContentView.pageControlY = 79;
        _pageContentView.swipeToExit = NO;
        _pageContentView.skipButton.hidden = YES;
        _pageContentView.tapToNext = YES;
        _pageContentView.useMotionEffects = true;
        _pageContentView.delegate = self;
        _pageContentView.pageControl.pageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _pageContentView.scrollView.bounces = true;
        [self addSubview:_pageContentView];
        [_pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _pageContentView;
}


@end
