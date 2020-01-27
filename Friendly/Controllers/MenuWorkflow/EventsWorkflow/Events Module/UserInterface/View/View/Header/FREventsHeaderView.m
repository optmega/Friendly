//
//  FREventsHeaderView.m
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventsHeaderView.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"
#import "FRSegmentView.h"
#import "UIImageHelper.h"

@interface FREventsHeaderView ()

@property (nonatomic, strong) UIToolbar* searchView;

@property (nonatomic, strong) FREventsHeaderViewModel* model;
@property (nonatomic, strong) UIView* separator;


@end

@implementation FREventsHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCommon];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCommon];
    }
    return self;
}

- (void)reloadData
{
    [self updateModel:self.model];
}

- (void)setupCommon
{
    [self searchView];
    [self updateSegment];
    [self segmentView];
    [self separator];
    self.backgroundColor = [UIColor whiteColor];
 
}

- (void)updateAlpha:(CGFloat)alpha
{
    self.searchBar.alpha = alpha;
    self.faceButton.alpha = alpha;
    self.filterButton.alpha = alpha;
}

- (void)updateModel:(FREventsHeaderViewModel*)model
{
    self.model = model;
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;

                            UIColor *color = [UIColor bs_colorWithHexString:@"ADB3C4"];
                            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.searchContent attributes:@{NSForegroundColorAttributeName: color}];
            }
        }
    }

//    self.searchBar.placeholder = model.searchContent;
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.photoUrl]];
//    [self.faceButton.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.faceButton setImage:image forState:UIControlStateNormal];
//    }];
}

- (UIToolbar*)searchView
{
    if (!_searchView)
    {
        _searchView = [UIToolbar new];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.translucent = NO;
        _searchView.barTintColor = [UIColor whiteColor];
        _searchView.barStyle = UIBarStyleBlackTranslucent;
        _searchBar.delegate = nil;
        _searchView.clipsToBounds = YES;
        [self addSubview:_searchView];
        
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.height.equalTo(@44);
        }];
    }
    return _searchView;
}


- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.segmentView addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.segmentView);
            make.top.equalTo(self.segmentView.mas_bottom);
            make.height.equalTo(@0.5);
        }];
    }
    return _separator;
}

- (FRSegmentView*)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [FRSegmentView new];
        _segmentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_segmentView];
        
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@40);
        }];
    }
    return _segmentView;
}

- (void)updateSegment
{
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    
    @weakify(self);
    [[face rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.model showUserProfileSelected];
    }];
    

    self.faceButton = face;
    face.bounds = CGRectMake( 0, 0, 30, 30 );
//    face.imageView.bounds = CGRectMake(0, 0, 30, 30);
//    face.clipsToBounds = YES;
//    face.layer.cornerRadius = 15;
//    face.layer.borderWidth = 2;
//    face.layer.borderColor = [UIColor whiteColor].CGColor;
//    face.backgroundColor = [UIColor blackColor];
    
    
    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    UIButton* filter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton = filter;
    [filter setImage:[FRStyleKit imageOfNavFilterCanvas] forState:UIControlStateNormal];
    filter.bounds = CGRectMake( 0, 0, 30, 30 );
    
    [[filter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.model showFilter];
    }];
    
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithCustomView:filter];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* customSearch = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    
    self.searchView.items = @[faceBtn, space, customSearch, space, filterBtn];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
    
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.backgroundColor = [UIColor bs_colorWithHexString:@"#EFF1F6"];
                textField.textColor = [UIColor bs_colorWithHexString:@"ADB3C4"];
                
                UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
                [inpView addGestureRecognizer:gest];
                
                textField.inputAccessoryView = inpView;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.autocorrectionType = UITextAutocorrectionTypeYes;
                UIImage* image = [UIImageHelper image:[FRStyleKit imageOfTabSearchCanvas] color:[UIColor bs_colorWithHexString:@"ADB3C4"]];
                UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(0, 0, 15, 15);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                textField.leftView = imageView;
                textField.tintColor = [UIColor whiteColor];
//                if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//                    UIColor *color = [UIColor bs_colorWithHexString:@"ADB3C4"];
//                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event search" attributes:@{NSForegroundColorAttributeName: color}];
//                } else {
//                    NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//                }
                
                break;
            }
        }
    }
}

- (void)endEditing
{
    self.searchBar.text = @"";
    [self endEditing:YES];
}

- (UISearchBar*)searchBar
{
    if (!_searchBar)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width-110;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.placeholder = FRLocalizedString(@"Search", nil);
        [self addSubview:_searchBar];
    }
    return _searchBar;
}


@end



