//
//  FRBaseDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRBaseDomainModelTransfer <NSObject>

- (NSDictionary*)domainModelDictionary;
- (NSString*)getJSONString;

@end

@interface FRBaseDomainModel : NSObject <FRBaseDomainModelTransfer>

@end
