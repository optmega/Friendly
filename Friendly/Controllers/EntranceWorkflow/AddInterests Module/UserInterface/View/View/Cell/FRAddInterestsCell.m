//
//  FRAddInterestsCell.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsCell.h"
#import "FRStyleKit.h"
#import "FRInterestsModel.h"


@interface FRAddInterestsCell ()

@property (nonatomic, strong) UIImageView* tagImage;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIImageView* checkImage;

@property (nonatomic, strong) FRAddInterestsCellViewModel* model;

@property (nonatomic, assign) BOOL axxx;



@end

@implementation FRAddInterestsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self checkImage];
        
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedGest)];
        [self addGestureRecognizer:gest];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return self;
}

- (void)updateWithModel:(FRAddInterestsCellViewModel*)model
{
    self.model = model;
    self.contentLabel.text = model.model.title;
    self.checkImage.image = self.model.isCheck ? [FRStyleKit imageOfAttendeeCheckmarkCanvasGreen] : nil;
    self.checkImage.layer.borderColor =  self.model.isCheck ? [UIColor bs_colorWithHexString:@"#6849FF"].CGColor : [UIColor bs_colorWithHexString:@"E8EBF1"].CGColor;

}

- (void)selectedGest
{
    [self.model selectedInterest:self.model.model.id];
    self.model.isCheck = !self.model.isCheck;
    self.axxx = !self.axxx;
    self.checkImage.image = self.model.isCheck ? [FRStyleKit imageOfAttendeeCheckmarkCanvasGreen] : nil;
    self.checkImage.layer.borderColor =  self.model.isCheck ? [UIColor bs_colorWithHexString:@"#6849FF"].CGColor : [UIColor bs_colorWithHexString:@"E8EBF1"].CGColor;
    
}


#pragma mark - Lazy Load

- (UIImageView*)tagImage
{
    if (!_tagImage)
    {
        _tagImage = [UIImageView new];
        _tagImage.image = [FRStyleKit imageOfHashtagCanvas];
        [self.contentView addSubview:_tagImage];
        
        [_tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(@20);
            make.height.width.equalTo(@20);
            
        }];
    }
    return _tagImage;
}

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _contentLabel.font = FONT_SF_DISPLAY_LIGHT(17);
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.tagImage.mas_right).offset(10);
            make.right.equalTo(self.checkImage.mas_left).offset(-10);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return _contentLabel;
}

- (UIImageView*)checkImage
{
    if (!_checkImage)
    {
        _checkImage = [UIImageView new];
        _checkImage.backgroundColor = [UIColor whiteColor];
        _checkImage.layer.cornerRadius = 12;
        _checkImage.layer.borderWidth = 1;
        _checkImage.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBF1"].CGColor;
        _checkImage.contentMode = UIViewContentModeScaleAspectFit;
       
        [self.contentView addSubview:_checkImage];
        
        
        [_checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@24);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _checkImage;
}

@end
