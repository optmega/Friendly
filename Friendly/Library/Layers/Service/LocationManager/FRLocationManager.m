//
//  FRLocationManager.m
//  Friendly
//
//  Created by Sergey Borichev on 01.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLocationManager.h"
@import GoogleMaps;
@import GooglePlaces;

@interface FRLocationManager () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, assign) CLLocationCoordinate2D location;

@end

@implementation FRLocationManager


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FRLocationManager* sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init 
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        self.location = CLLocationCoordinate2DMake(0, 0);
        [self startUpdateLocationManager];
    }
    return self;
}

+ (void)placeNearby:(void(^)(NSArray* places))places
{

    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        
        
        NSLog(@"%@", error);
        places(likelihoodList.likelihoods);
    }];
}

+ (void)placeAutocomplete:(NSString*)text
                   places:(void(^)(NSArray<GMSAutocompletePrediction*>* places))places {
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    [[GMSPlacesClient sharedClient] autocompleteQuery:text
                                               bounds:nil
                                               filter:filter
                                             callback:^(NSArray<GMSAutocompletePrediction*> *results, NSError *error) {
                                                 if (error != nil) {
                                                     return;
                                                 }
                                                 
                                                 places(results);
                                                 NSLog(@"%@", results);
                                                 
                                             }];
}

- (void)startUpdateLocationManager
{
    [locationManager startUpdatingLocation];
}

- (void)stopUpdateLocationManager
{
    [locationManager stopUpdatingLocation];
}

- (BOOL)verifiLocationManager
{
    if (![CLLocationManager locationServicesEnabled])
    {
        [self showDaniedAlert];
        return false;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined: {
            
            [locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted: {
            
            break;
        }
        case kCLAuthorizationStatusDenied: {
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [self showDaniedAlert];
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways: {
            
            return YES;
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            
            return YES;
            break;
        }
    }
    
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.location = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
}

- (void)showDaniedAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:FRLocalizedString(@"Location Services Disabled!", nil)
                                                        message:FRLocalizedString(@"Please enable Location Based Services for better results! We promise to keep your location private", nil)
                                                       delegate:self
                                              cancelButtonTitle:FRLocalizedString(@"Settings", nil)
                                              otherButtonTitles:FRLocalizedString(@"Cancel", nil), nil];
    if (![CLLocationManager locationServicesEnabled])
    {
        alertView.tag = 100;
    }
    else
    {
        alertView.tag = 200;
    }
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        if (alertView.tag == 100)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        else if (alertView.tag == 200)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    else if(buttonIndex == 1)
    {
    }
}


@end
