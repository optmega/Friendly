
//
//  Created by Sergey Borichev on 30.11.15.
//  Copyright © 2015 TecSynt. All rights reserved.

//

@interface NSObject (SMSafeValues)

+ (NSString*)bs_safeString:(NSString*)value;
+ (NSDictionary*)bs_safeDictionary:(NSDictionary*)dict;

@end
