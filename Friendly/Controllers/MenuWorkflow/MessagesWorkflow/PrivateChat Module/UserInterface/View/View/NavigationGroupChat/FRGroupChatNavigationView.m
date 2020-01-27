//
//  FRGroupChatNavigationView.m
//  Friendly
//
//  Created by Sergey on 14.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupChatNavigationView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@implementation FRGroupChatNavigationView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.leftItem setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]] forState:UIControlStateNormal];
    
    [self.rightItem setImage:[UIImageHelper image:[FRStyleKit imageOfFeildMoreOptionsCanvas] color:[UIColor bs_colorWithHexString:@"939BAF"]] forState:UIControlStateNormal];
    
}

@end
