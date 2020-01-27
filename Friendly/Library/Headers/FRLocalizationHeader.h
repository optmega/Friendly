//
//  FRGlobalHeader.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLocalizationSystem.h"

#define FRLocalizedString(key, comment) [[FRLocalizationSystem sharedLocalizationSystem] localizedStringForKey:(key) value:(comment)]

#define FRLocalizationSetLanguage(language) [[FRLocalizationSystem sharedLocalizationSystem] setLanguage:(language)]

#define FRLocalizationGetLanguage [[FRLocalizationSystem sharedLocalizationSystem] getLanguage]