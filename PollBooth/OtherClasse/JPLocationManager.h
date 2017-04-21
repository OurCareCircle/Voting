//
//  Location.h
//  kiddoApp
//
//  Created by pratik on 02-11-12.
//  Copyright (c) 2012 AppMaggot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol JPLocationManagerDelegate;

@interface JPLocationManager : NSObject <CLLocationManagerDelegate>

- (void)findUpdatedLocation;
- (void)startMonitoringRegion:(CLRegion*)region;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,weak) id <JPLocationManagerDelegate> delegate;

@end


@protocol JPLocationManagerDelegate <NSObject>

@optional
-(void)location:(JPLocationManager*)locationManager didFoundNewLocation:(CLLocation*)location;
-(void)location:(JPLocationManager*)locationManager address:(NSDictionary*)address;

@end
