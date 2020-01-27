//
//  FRLetsGoContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLetsGoContentView.h"
#import "NSString+SizeFit.h"
#import "FRUserManager.h"

@interface FRLetsGoContentView ()


@end

@implementation FRLetsGoContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self backgroundImage];
        [self photo];
        [self smileLabel];
        [self smile];
        [self contentLabel];
        [self letsGoButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat size = [self.contentLabel.text fontSizeWithFont:self.contentLabel.font constrainedToSize:self.contentLabel.bounds.size];
    self.contentLabel.font = FONT_SF_DISPLAY_LIGHT(size);
}


#pragma mark - Lazy Load

- (UIImageView*)backgroundImage
{
    if (!_backgroundImage)
    {
        _backgroundImage = [UIImageView new];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed:@"Login-flow-bg-1"];
        [self addSubview:_backgroundImage];
        
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _backgroundImage;
}

- (UIImageView*)photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
//        _photo.image = [UIImage imageNamed:@"Login-flow_ Main user"];
     
        _photo.layer.cornerRadius = 75;
        _photo.clipsToBounds = YES;
        _photo.layer.borderColor = [UIColor whiteColor].CGColor;
        _photo.layer.borderWidth = 4;
        [self addSubview:_photo];
        
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.smileLabel.mas_top).offset(-40);
            self.heightConstraint = make.height.equalTo(@0);//70
            make.width.equalTo(_photo.mas_height);
//            make.width.height.equalTo(@150);
        }];
    }
    return _photo;
}

- (UILabel*)smileLabel
{
    if (!_smileLabel)
    {
        _smileLabel = [UILabel new];
        _smileLabel.text = FRLocalizedString(@"We're glad to have you!", nil);
        _smileLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _smileLabel.font = FONT_SF_DISPLAY_LIGHT(21);
        _smileLabel.textAlignment = NSTextAlignmentCenter;
        _smileLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_smileLabel];
        
        [_smileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-5);
            if (IS_IPHONE_5)
            {
            make.bottom.equalTo(self.mas_centerY).offset(-10);
             make.width.equalTo(@180);
            }
            else
            {
                make.bottom.equalTo(self.mas_centerY).offset(-20);
                make.width.equalTo(@220);
            }

//            make.left.equalTo(self).offset(50);
//            make.right.equalTo(self).offset(-60);
        }];
    }
    return _smileLabel;
}

- (UILabel*)smile
{
    if (!_smile)
    {
        _smile = [UILabel new];
        _smile.text = FRLocalizedString(@"😁", nil);
        _smile.textColor = [UIColor whiteColor];
        _smile.font = FONT_SF_DISPLAY_LIGHT(35);
        _smile.textAlignment = NSTextAlignmentCenter;
//        _smile.adjustsFontSizeToFitWidth = YES;
        [self.backgroundImage addSubview:_smile];
        
        [_smile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.smileLabel).offset(7);
            make.left.equalTo(self.smileLabel.mas_right);
            make.height.equalTo(@38);
//            make.width.height.equalTo(@31);
        }];
    }
    return _smile;
}

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.text = FRLocalizedString(@"Now tell us a little about yourself\nand what you like to help us build\nyour profile", nil);
        _contentLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:FRLocalizedString(@"Now tell us a little about yourself\nand what you like to help us build\nyour profile", nil)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentLabel.text.length)];
        
    
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.attributedText = attributedString;
        
        _contentLabel.numberOfLines = 3;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = FONT_SF_DISPLAY_LIGHT(21);
        
        
        
        
        _contentLabel.minimumScaleFactor = 0.5;
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
        }];
    }
    return _contentLabel;
}

- (UIButton*)letsGoButton
{
    if (!_letsGoButton)
    {
        _letsGoButton = [UIButton new];
        [_letsGoButton setTitle:FRLocalizedString(@"Let's go!", nil) forState:UIControlStateNormal];
//        [_letsGoButton setTitleColor:[UIColor bs_colorWithHexString:@"#00B5FF"] forState:UIControlStateNormal];
        [_letsGoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_letsGoButton setTitleColor:[[UIColor  bs_colorWithHexString:@"#8067FF"] colorWithAlphaComponent:0.9] forState:UIControlStateHighlighted];
        [_letsGoButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9] forState:UIControlStateHighlighted];
        _letsGoButton.layer.cornerRadius = 6;
        _letsGoButton.backgroundColor = [UIColor bs_colorWithHexString:@"#00B5FF"];
        _letsGoButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [self addSubview:_letsGoButton];
        
        [_letsGoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentLabel.mas_bottom).offset(40);
            make.centerX.equalTo(self);
            make.height.equalTo(@50);
            make.left.equalTo(self).offset(87);
            make.right.equalTo(self).offset(-87);
        }];
    }
    return _letsGoButton;
}



@end
