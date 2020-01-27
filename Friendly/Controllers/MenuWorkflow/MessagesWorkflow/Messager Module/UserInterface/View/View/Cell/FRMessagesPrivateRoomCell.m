//
//  FRMessagesPrivateRoomCell.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagesPrivateRoomCell.h"
#import "FRMessagesPrivateRoomCellViewModel.h"

@interface FRMessagesPrivateRoomCell ()

@property (nonatomic, strong) FRMessagesPrivateRoomCellViewModel* model;
@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, strong) UIView* statusBackView;

@end


@implementation FRMessagesPrivateRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.buttonWidth = [[UIScreen mainScreen] bounds].size.height <= 568.0f ? 60 : 80;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 15);
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedCell)];
        
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)selectedCell
{
    [self.model selectedRoom];
}

- (void)updateWithModel:(FRMessagesPrivateRoomCellViewModel*)model
{
    self.model = model;
    
    [self.model updatePhoto:self.photoImage];
    self.titleLabel.text = model.name;
    self.subtitleLabel.text = model.lastMessage;
    self.dateLabel.text = model.date;
    self.statusBackView.hidden = 
    self.statusImage.hidden = !model.isNewMessage;
}



#pragma mark - LazyLoad

- (UIImageView*)photoImage
{
    if (!_photoImage)
    {
        _photoImage = [UIImageView new];
        _photoImage.backgroundColor = [UIColor grayColor];
        _photoImage.clipsToBounds = YES;
        _photoImage.layer.cornerRadius = 22.5;
        [self.contentView addSubview:_photoImage];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@45);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _photoImage;
}

- (UIView*)statusBackView
{
    if (!_statusBackView)
    {
        _statusBackView = [UIView new];
        _statusBackView.backgroundColor = [UIColor whiteColor];
        _statusBackView.layer.cornerRadius = 6;
        
        [self.contentView addSubview:_statusBackView];
        [_statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@12);
            make.centerX.equalTo(self.photoImage.mas_right).offset(-3);
            make.bottom.equalTo(self.mas_centerY).offset(-4);
        }];
    }
    return _statusBackView;
}


- (UIImageView*)statusImage
{
    if (!_statusImage)
    {
        _statusImage = [UIImageView new];
        _statusImage.layer.cornerRadius = 5;
        _statusImage.clipsToBounds = YES;
        _statusImage.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        [self.statusBackView addSubview:_statusImage];
        
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@10);
            make.centerX.equalTo(self.photoImage.mas_right).offset(-3);
            make.bottom.equalTo(self.mas_centerY).offset(-5);
        }];
    }
    return _statusImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.photoImage.mas_right).offset(10);
            make.right.equalTo(self.dateLabel.mas_left).offset(-10);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(2);
            make.left.equalTo(self.photoImage.mas_right).offset(10);
            make.right.equalTo(self.dateLabel.mas_left).offset(-10);
            
        }];
    }
    return _subtitleLabel;
}

- (UILabel*)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _dateLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.greaterThanOrEqualTo(@50);
        }];
    }
    return _dateLabel;
}


@end




#pragma mark - Lazy Load



