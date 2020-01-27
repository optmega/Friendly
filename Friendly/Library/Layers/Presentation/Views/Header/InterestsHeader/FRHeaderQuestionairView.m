//
//  FRHeaderQuestionairView.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHeaderQuestionairView.h"
#import "NSString+SizeFit.h"

@interface FRHeaderQuestionairView()



@end

static CGFloat const kTitleSideOffset = 50;
static CGFloat const kSubTitleOffset = 40;

@implementation FRHeaderQuestionairView

- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle
{
    self = [self init];
    if (self)
    {
        [self updateTitle:title subtitle:subtitle];
    }
    return  self;
}

- (void)updateTitle:(NSString*)title subtitle:(NSString*)subtitle
{
    self.titleLabel.text = title;
    self.subtitleLabel.attributedText = [self attributedStringWithString:subtitle];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Questionair - header"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat size = [self.subtitleLabel.text fontSizeWithFont:FONT_PROXIMA_NOVA_SEMIBOLD(21) constrainedToSize:self.subtitleLabel.bounds.size];
    self.subtitleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(size);
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_LIGHT(23);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(kTitleSideOffset);
            make.right.equalTo(self).offset(-kTitleSideOffset);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.numberOfLines = 2;
               
        [self addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
            make.left.equalTo(self).offset(kSubTitleOffset);
            make.right.equalTo(self).offset(-kSubTitleOffset);
            
        }];
    }
    
    return _subtitleLabel;
}

- (NSAttributedString*)attributedStringWithString:(NSString*)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    
    return attributedString;

}
@end
