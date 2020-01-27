//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@protocol FRAddInterestsModuleInterface <NSObject>

- (void)backSelected;
- (void)continueSelected;
- (void)addTagSelected:(NSString*)tag;

@end
