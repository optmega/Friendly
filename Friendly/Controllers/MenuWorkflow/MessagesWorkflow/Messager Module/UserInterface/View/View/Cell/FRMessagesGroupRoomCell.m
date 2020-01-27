//
//  FRMessagesGroupRoomCell.m
//  Friendly
//
//  Created by Sergey on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagesGroupRoomCell.h"

@interface FRGroupMessageView : UIView

@property (nonatomic, strong) UIImageView* photoImage;
@property (nonatomic, strong) UIView* statusBackView;
@property (nonatomic, strong) UIImageView* statusImage;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UILabel* dateLabel;


@end


@interface FRMessagesGroupRoomCell ()


@property (nonatomic, strong) UILabel* dayOfWeek;
@property (nonatomic, strong) UILabel* dayOfMounth;
@property (nonatomic, strong) UILabel* eventName;

@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) NSArray* images;

@property (nonatomic, strong) FRMessagesGroupRoomCellViewModel* model;

@property (nonatomic, strong) UIView* backView;

@property (nonatomic, strong) FRGroupMessageView* messageView;
@end

@implementation FRMessagesGroupRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self separator];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedGroup)];
        [self.contentView addGestureRecognizer:tap];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 15);
        [self messageView];
    }
    
    return self;
}


- (void)updateWithModel:(FRMessagesGroupRoomCellViewModel*)model
{
    self.model = model;
    self.dayOfWeek.text = model.dayOfWeak;
    self.dayOfMounth.text = model.dayOfMonth;
    self.eventName.text = model.name;
    [model updateUserImages:self.images];
    
    [model setLastMessageUserImage:self.messageView.photoImage];
    self.messageView.titleLabel.text = FRLocalizedString(@"Group chat", nil);
    self.messageView.dateLabel.text = model.date;
    self.messageView.subtitleLabel.text = model.lastMessage;
    self.messageView.statusBackView.hidden = ![model isNewMessage];
}

- (void)selectedGroup
{
    [self.model selectedGroupRoom];
}


#pragma mark - Lazy Load

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
    }
    return _backView;
}

- (FRGroupMessageView*)messageView
{
    if (!_messageView)
    {
        _messageView = [FRGroupMessageView new];
        [self.contentView addSubview:_messageView];
        [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_centerY);
        }];
    }
    return _messageView;
}

- (UILabel*)dayOfWeek
{
    if (!_dayOfWeek)
    {
        _dayOfWeek = [UILabel new];
        _dayOfWeek.textAlignment = NSTextAlignmentCenter;
        _dayOfWeek.textColor = [UIColor redColor];
        _dayOfWeek.font = FONT_SF_TEXT_REGULAR(10);
        [self.backView addSubview:_dayOfWeek];
        [_dayOfWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dayOfMounth);
            make.bottom.equalTo(self.dayOfMounth.mas_top).offset(-1);
        }];
    }
    return _dayOfWeek;
}

- (UILabel*)dayOfMounth
{
    if (!_dayOfMounth)
    {
        _dayOfMounth = [UILabel new];
        _dayOfMounth.textAlignment = NSTextAlignmentCenter;
        _dayOfMounth.font = FONT_SF_TEXT_REGULAR(16);
        _dayOfMounth.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        [self.backView addSubview:_dayOfMounth];
        [_dayOfMounth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).offset(17);
            make.top.equalTo(self.backView.mas_centerY);
            make.width.equalTo(@40);
            
        }];
    }
    return _dayOfMounth;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        
        [self.backView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayOfMounth.mas_right).offset(2);
            make.centerY.equalTo(self.backView);
            make.width.equalTo(@0.5);
            make.height.equalTo(@25);
        }];
    }
    return _separator;
}

- (UILabel*)eventName
{
    if (!_eventName)
    {
        _eventName = [UILabel new];
        [self.backView addSubview:_eventName];
        [_eventName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backView);
            make.left.equalTo(self.separator.mas_right).offset(10);
            make.right.equalTo(self.backView).offset(-115);
        }];
    }
    return _eventName;
}

- (NSArray*)images
{
    if (!_images)
    {
        NSMutableArray* array = [NSMutableArray array];
        
        NSInteger rightOffset = 20;
        for (NSInteger i = 0; i<4; i++) {
            UIImageView* im = [UIImageView new];
            im.backgroundColor = [UIColor redColor];
            im.layer.cornerRadius = 12.5;
            im.layer.borderColor = [UIColor whiteColor].CGColor;
            im.layer.borderWidth = 1;
            im.hidden = YES;
            im.clipsToBounds = YES;
            [self.backView addSubview:im];
            [im mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(@25);
                make.centerY.equalTo(self.backView);
                make.right.equalTo(self.backView).offset(-(20 + i*rightOffset));
            }];
            
            [array addObject:im];
        }
        _images = array;
    }
    return _images;
}

@end


@implementation FRGroupMessageView

- (UIImageView*)photoImage
{
    if (!_photoImage)
    {
        _photoImage = [UIImageView new];
        _photoImage.backgroundColor = [UIColor grayColor];
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        _photoImage.clipsToBounds = YES;
        _photoImage.layer.cornerRadius = 22.5;
        [self addSubview:_photoImage];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@45);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
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
    
        
        UIView* redDot = [UIView new];
        redDot.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        redDot.layer.cornerRadius = 4;
        [_statusBackView addSubview:redDot];
        [redDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_statusBackView);
            make.height.width.equalTo(@8);
        }];
        
        
        [self addSubview:_statusBackView];
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
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
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
        [self addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY);
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
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(-15);
            make.width.greaterThanOrEqualTo(@50);
        }];
    }
    return _dateLabel;
}


@end
