//
//  BSRuntimeHelper.h
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface BSRuntimeHelper : NSObject

+ (NSString*)classStringForClass:(Class)class;
+ (NSString*)modelStringForClass:(Class)class;

@end
