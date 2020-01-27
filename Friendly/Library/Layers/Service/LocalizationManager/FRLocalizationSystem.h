//
//  FRLocalizationSystem.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRLocalizationSystem : NSObject

+ (FRLocalizationSystem *)sharedLocalizationSystem;
- (NSString *) localizedStringForKey:(NSString *)key value:(NSString *)comment;
- (void) setLanguage:(NSString *) language;
- (NSString *) getLanguage;

@end
