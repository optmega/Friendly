//
//  FRCreateEventCreateActionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventCreateActionCell.h"

@interface FRCreateEventCreateActionCell ()

@property (nonatomic, strong) UIButton* createButton;
@property (nonatomic, strong) FRCreateEventCreateActionCellViewModel* model;
@end

@implementation FRCreateEventCreateActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createButton];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventCreateActionCellViewModel*)model
{
    self.model = model;
}


#pragma mark - Lazy Load

- (UIButton*)createButton
{
    if (!_createButton)
    {
        _createButton = [UIButton new];
        _createButton.backgroundColor = [[UIColor bs_colorWithHexString:kPurpleColor] colorWithAlphaComponent:0.95];
        [_createButton setTitle:FRLocalizedString(@"Create event", nil) forState:UIControlStateNormal];
        _createButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(16);
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_createButton];
        
        [_createButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _createButton;
}

@end
