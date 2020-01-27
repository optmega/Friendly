//
//  FRShareEventCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRShareEventCell.h"
#import "FREventModel.h"
#import "FRStyleKit.h"

@interface FRShareEventCell()

@property (strong, nonatomic) FREvent* model;
@property (nonatomic, strong) FREventsCellViewModel* viewModel;

@end

@implementation FRShareEventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.eventTypeButton.hidden = YES;
        self.shareButton.hidden = YES;
        self.footerView.hidden = YES;
        [self dateView];
        [self.eventImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self.contentView);
        }];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eventImage).offset(40);
            make.right.equalTo(self.eventImage).offset(-40);
            make.height.lessThanOrEqualTo(@70);
            make.centerY.equalTo(self.eventImage).offset(10);
        }];

        self.userImage.hidden = YES;
        self.partnerAvatar.hidden = YES;
        }
    return self;
}

- (void)_updateWithPartner
{
    self.partnerAvatar.hidden = YES;
    self.userImage.hidden = YES;
}

//- (void) updateWithModel:(id)model
//{
//    self.viewModel = model;
//    self.model = [model domainModel];
////    [self.distanceLabel setText:model.distance];
//    self.titleLabel.text = self.model.title;
//    [model updateUserPhoto:self.userImage];
//    
//    [self _setGender:[self.model.gender integerValue]];
//    [self.dateView updateDateViewWithDate:self.model.event_start];
//    [model updateEventPhoto:self.eventImage];
//}

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


#pragma mark - LazyLoad

-(FRMyEventsDateView*) dateView
{
    if (!_dateView)
    {
        _dateView = [FRMyEventsDateView new];
         _dateView.layer.cornerRadius = 5;
        _dateView.backgroundColor = [UIColor whiteColor];
        _dateView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _dateView.layer.borderWidth = 3;
        [self.contentView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@37);
            make.centerX.equalTo(self.eventImage);
                //            make.top.equalTo(self.eventImage).offset(30);
//                make.width.height.equalTo(@75);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-5);

        }];
    }
    return _dateView;
}
@end
