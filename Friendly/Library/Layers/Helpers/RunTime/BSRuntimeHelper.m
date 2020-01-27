//
//  BSRuntimeHelper.h
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSRuntimeHelper.h"

@implementation BSRuntimeHelper

+ (NSString *)classStringForClass:(Class)class
{
    NSString * classString = NSStringFromClass(class);
    if ([classString rangeOfString:@"."].location != NSNotFound)
    {
        // Swift class, format <ModuleName>.<ClassName>
        classString = [[classString componentsSeparatedByString:@"."] lastObject];
    }
    return classString;
}

+ (NSString *)modelStringForClass:(Class)class
{
    NSString * classString = [self classStringForClass:class];
    if ([classString isEqualToString:@"__NSCFConstantString"] ||
        [classString isEqualToString:@"__NSCFString"] ||
        [classString isEqualToString:@"_NSContiguousString"] ||
        [classString isEqualToString:@"NSTaggedPointerString"] ||
        class == [NSMutableString class])
    {
        return @"NSString";
    }
    if ([classString isEqualToString:@"__NSCFNumber"] ||
        [classString isEqualToString:@"__NSCFBoolean"])
    {
        return @"NSNumber";
    }
    if ([classString isEqualToString:@"__NSDictionaryI"] ||
        [classString isEqualToString:@"__NSDictionaryM"] ||
       ([classString rangeOfString:@"_NativeDictionaryStorageOwner"].location != NSNotFound) ||
        class == [NSMutableDictionary class])
    {
        return @"NSDictionary";
    }
    if ([classString isEqualToString:@"__NSArrayI"] ||
        [classString isEqualToString:@"__NSArrayM"] ||
        ([classString rangeOfString:@"_ContiguousArrayStorage"].location != NSNotFound) ||
        class == [NSMutableArray class])
    {
        return @"NSArray";
    }
    if ([classString isEqualToString:@"__NSDate"] || [classString isEqualToString:@"__NSTaggedDate"] || class == [NSDate class])
    {
        return @"NSDate";
    }
    return classString;
}

@end
