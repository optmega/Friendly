//
//  DateView.h
//  Project
//
//  Created by Zaslavskaya Yevheniya on 01.03.16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventPreviewEventViewCellViewModel.h"

@interface FREventPreviewDateView : UIView

- (void)updateWithModel:(FREventPreviewEventViewCellViewModel*)model;

@end
