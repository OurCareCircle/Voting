//
//  PBAppDelegate.m
//  PollBooth
//
//  Created by iOSDeveloper2 on 05/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import "PBAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>


@interface PBAppDelegate () <JPLocationManagerDelegate>

@end


@implementation PBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    __appDelegator = (PBAppDelegate*)application.delegate;
    [GMSServices provideAPIKey:kAPIKey];
    self.jpManager = [[JPLocationManager alloc]init];
    self.jpManager.delegate = self;
    return YES;
}

-(void)sendElapsedTime:(NSDictionary*)timeDict
                region:(NSString*)identifier
{
    NSDate *dateStart   = timeDict[kSartTime];
    NSDate *dateEnd     = timeDict[kEndTime];
    double time = [dateEnd timeIntervalSinceDate:dateStart];
    int minutes = time/60;
    
    NSArray *coordinates = [timeDict[kRegion] componentsSeparatedByString:@","];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([coordinates[0] doubleValue], [coordinates[1] doubleValue]);
    
    [WebServiceCalls sendElapsedTime:minutes
                        onCoordinate:location
                               block:^(id JSON, WebServiceResult result)
     {
         if(result == WebServiceResultSuccess)
         {
             [UserDefault removeObjectForKey:identifier];
             [UserDefault synchronize];
            // showAletViewWithMessage([NSString stringWithFormat:@"Wait time:%f",time]);
             NSLog(@"sent exit time successfully");
         }
     }];
}

- (void)location:(JPLocationManager *)locationManager didFoundNewLocation:(CLLocation *)aLocation
{
    [DefaultCenter postNotificationName:PBNotificationFoundNewLocation object:aLocation];
}

- (void)startMonitorRegion:(CLRegion*)region
{
    [self.jpManager startMonitoringRegion:region];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
		
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
		[self.jpManager.locationManager stopUpdatingLocation];
		[self.jpManager.locationManager startMonitoringSignificantLocationChanges];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSDictionary *aDict =  [UserDefault dictionaryRepresentation];
    [aDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if( [obj isKindOfClass:[NSDictionary class]]    &&
             obj[kUpFlag]                               &&
             obj[kEndTime]                              &&
             obj[kSartTime]                             &&
             obj[kRegion]                               &&
            [obj[kUpFlag] isEqual:@(1)] )
        {
            [self sendElapsedTime:obj region:key];
        }
    }];
    
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.jpManager.locationManager stopMonitoringSignificantLocationChanges];
		[self.jpManager.locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
    }

}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
