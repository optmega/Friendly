//
//  FRMyProfileInterestsCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 26.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileInterestsCellViewModel.h"
#import "BSTagView.h"
#import "Interest.h"

@interface FRMyProfileInterestsCellViewModel ()

@property (nonatomic, assign) CGFloat height;


@end

@implementation FRMyProfileInterestsCellViewModel

//- (CGFloat)height
//{
////    if (!_height)
////    {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
//        _height = [BSTagView heightTagViewWithWidth:width tags:self.tags];
////    }
//    return _height;
//}

- (void)setTags:(NSArray *)tags
{
    if ([[tags lastObject] isKindOfClass:[Interest class]]) {
        NSMutableArray *uniqueTagArray = [NSMutableArray new];
        NSArray *titles;
        for (Interest* interest in tags) {
            titles = [uniqueTagArray valueForKey:@"title"];
            if (![titles containsObject:interest.title]) {
                [uniqueTagArray addObject:interest];
            }
        }
        _tags = [uniqueTagArray copy];
    } else {
        _tags = tags;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
    _height = [BSTagView heightTagViewWithWidth:width tags:self.tags];
}

@end
