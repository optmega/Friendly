//
//  FRLoaderView.m
//  Friendly
//
//  Created by Sergey on 09.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLoaderView.h"
#import "UIImageView+WebCache.h"

@interface FRLoaderView ()

@property (nonatomic, weak) IBOutlet UIImageView* eventImage;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIView* loadIndicatorView;

@property (nonatomic, strong) UIView* progressView;

@end

@implementation FRLoaderView



- (void)updateWithEvent:(CreateEvent*)createEvent
{
    if (createEvent.placeImage) {
        self.eventImage.image = [UIImage imageWithData:createEvent.placeImage];
    } else {
        [self.eventImage sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:createEvent.image_url]]];
    }
    
    NSString* postingStr = @"Posting";
    
    NSString* str = [NSString stringWithFormat:@"%@ '%@'", postingStr, createEvent.title];
    
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor bs_colorWithHexString:kFieldTextColor] range:NSMakeRange(0,postingStr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor bs_colorWithHexString:KTextTitleColor] range:NSMakeRange(postingStr.length, createEvent.title.length)];
    
    self.titleLabel.attributedText = attr;
}

- (UIView*)progressView
{
    if (!_progressView)
    {
        _progressView = [UIView new];
        _progressView.backgroundColor = [UIColor bs_colorWithHexString:@"1FB7FD"];
        [self.loadIndicatorView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.loadIndicatorView);
//            make.width.equalTo(self.loadIndicatorView).multipliedBy(0);
        }];
    }
    return _progressView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.94];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UploadImageProgress" object:nil];
}

- (void)updateProgress:(NSNotification*)not {

    NSInteger progress = ((NSNumber*)not.object).integerValue;
        
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width / 100 * progress));
        }];
//    NSLog(@"%@ - ss", not.object);
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
