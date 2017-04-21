 //
//  Location.m
//  kiddoApp
//
//  Created by pratik on 02-11-12.
//  Copyright (c) 2012 AppMaggot. All rights reserved.
//

#import "JPLocationManager.h"
#import "Constant.h"


@implementation JPLocationManager


-(id)init;
{
    self = [super init];
    if(self)
    {
         self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
         self.locationManager.distanceFilter = kDistanceAccuracy;
         self.locationManager.desiredAccuracy= kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

-(void)startMonitoringRegion:(CLRegion*)region
{
    if ([CLLocationManager regionMonitoringAvailable])
    {
        [self.locationManager startMonitoringForRegion:region
                                       desiredAccuracy:kCLLocationAccuracyBest];
     //   showAletViewWithMessage([NSString stringWithFormat:@"start : %@",region]);
        NSLog(@"Monitored regions : %@",self.locationManager.monitoredRegions);
    }
    else
    {
        NSLog(@"Region monitoring is not supported.");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = locations[0];
    NSLog(@"New Location found is %@",newLocation);
    NSLog(@"Ranged region : %@",self.locationManager.rangedRegions);
    NSLog(@"Monitored regions : %@",self.locationManager.monitoredRegions);
    if ([self.delegate respondsToSelector:@selector(location:didFoundNewLocation:)]) {
        [self.delegate location:self didFoundNewLocation:newLocation];
        
        //stop updating repeatedly-Sanjay
        [manager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   // showAletViewWithMessage([NSString stringWithFormat:@"%@",error.debugDescription]);
    NSLog(@"got error in location manager update : %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [ UserDefault setObject:@{ kSartTime  : [NSDate date],
                               kUpFlag    : @(0),
                               kRegion    : [NSString stringWithFormat:@"%f,%f",
                                           region.center.latitude,region.center.longitude] }
                     forKey:region.identifier ];
    [ UserDefault synchronize ];
    /* Temporary */
    //showAletViewWithMessage([NSString stringWithFormat:@"Enter in monitoring area:%@",region]);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSDictionary *timeDict = [UserDefault objectForKey:region.identifier];
    if(timeDict)
    {
        NSMutableDictionary *mutTimeDict = [timeDict mutableCopy];
        mutTimeDict[kEndTime]   = [NSDate date];
        mutTimeDict[kUpFlag]    = @(1);
        [UserDefault setObject:mutTimeDict forKey:region.identifier];
        [UserDefault synchronize];
        
        __block UIBackgroundTaskIdentifier backIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            if(![UserDefault objectForKey:region.identifier])
                [[UIApplication sharedApplication]endBackgroundTask:backIdentifier];
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [__appDelegator sendElapsedTime:mutTimeDict region:region.identifier];
        });
    }
    /* Temporary */
    //showAletViewWithMessage([NSString stringWithFormat:@"Exit from monitoring area : %@",region]);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion %@ %@",
          region, error.localizedDescription);
    for (CLRegion *monitoredRegion in manager.monitoredRegions) {
        NSLog(@"monitoredRegion: %@", monitoredRegion);
        //clear monitoring for this region
        [manager stopMonitoringForRegion:monitoredRegion];
    }
    
    /* Temporary */
    showAletViewWithMessage([NSString stringWithFormat:@"Monitoring Fail - %@",error.debugDescription]);
    
    
}

-(void)findUpdatedLocation
{
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}

-(void)findAddressFromLocation:(CLLocation*)location
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
        NSLog(@"new addresses found by location manager : %@",placemarks);
        if(placemarks.count) {
            CLPlacemark *place = placemarks[0];
            if ([self.delegate respondsToSelector:@selector(location:address:)])
                [self.delegate location:self address:place.addressDictionary];
        }
    }];
}


@end
