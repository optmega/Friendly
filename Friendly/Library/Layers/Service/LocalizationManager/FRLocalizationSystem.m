//
//  FRLocalizationSystem.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "FRLocalizationSystem.h"

@implementation FRLocalizationSystem

static FRLocalizationSystem *_sharedLocalizationSystem = nil;
static NSBundle *bundle = nil;
static NSString *_currentLanguage = nil;


+ (FRLocalizationSystem *) sharedLocalizationSystem
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLocalizationSystem = [self new];
    });

    return _sharedLocalizationSystem;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        bundle = [NSBundle mainBundle];
    }
    return self;
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{
    return [bundle localizedStringForKey:key value:comment table:nil];
}

- (void) setLanguage:(NSString*) lang
{
    if (_currentLanguage && [lang isEqualToString:_currentLanguage])
    {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    _currentLanguage = lang;
    
    if (path == nil)
    {
        [self resetLocalization]; 
    }
    else
    {
        bundle = [NSBundle bundleWithPath:path];
    }
    [[NSUserDefaults standardUserDefaults] bs_updateObject:[NSObject bs_safeString:lang] forKey:kLocalization];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocalizationChangedNotification object:nil];
 }

- (NSString*) getLanguage
{
    if (!_currentLanguage)
    {
        NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        _currentLanguage = [languages objectAtIndex:0];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:_currentLanguage ofType:@"lproj"];
        
        if (path == nil)
        {
            [self resetLocalization];
            _currentLanguage = @"en";         }
    }
    
    return _currentLanguage;
}

- (void)resetLocalization
{
    _currentLanguage = nil;
    bundle = [NSBundle mainBundle];
}


@end
