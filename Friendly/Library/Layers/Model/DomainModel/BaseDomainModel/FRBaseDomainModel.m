//
//  FRBaseDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"

@implementation FRBaseDomainModel

- (NSDictionary*)domainModelDictionary
{
    NSString * reason = [NSString stringWithFormat:@"You must override this method - %@ for class - %@",
                         NSStringFromSelector(_cmd), NSStringFromClass([self class])];
    NSException * exc =
    [NSException exceptionWithName:[NSString stringWithFormat:@"%@ Exception", NSStringFromClass([self class])]
                            reason:reason
                          userInfo:nil];
    
    [exc raise];

    return nil;
}

- (NSString*)getJSONString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject: [self domainModelDictionary]
                                                       options: NSJSONWritingPrettyPrinted
                                                         error: nil];
    return [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
}

@end
