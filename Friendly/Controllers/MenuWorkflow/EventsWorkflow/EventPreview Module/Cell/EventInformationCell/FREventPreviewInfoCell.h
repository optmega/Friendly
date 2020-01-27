//
//  FRInformationTableViewCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventModel.h"
#import "FREventPreviewInfoCellViewModel.h"

typedef NS_ENUM(NSInteger, FRInfoCellType) {
    FRInfoCellTypeMeetTime,
    FRInfoCellTypeWhere,
    FRInfoCellTypeOpenToFriends,
    FRInfoCellTypeHostsNumber,
};

@protocol FREventPreviewInfoCellDelegate <NSObject>

-(void)expandMap:(BOOL)isExpanding;

@end

@interface FREventPreviewInfoCell : UITableViewCell

@property (strong, nonatomic) UILabel* questionText;
@property (strong, nonatomic) UILabel* answerText;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UIView* separator;
@property (weak, nonatomic) id<FREventPreviewInfoCellDelegate> delegate;
- (void) updateWithModel:(FREventPreviewInfoCellViewModel*)model;
- (void) updateWhereInfoCellWithAttendingStatus:(NSString*)name lat:(NSString*)lat lon:(NSString*)lon;
- (void) updateTimeInfoCellWithAttendingStatus:(NSDate*)time;
- (void) updateMapWithOffset:(CGFloat)offset;

@end
