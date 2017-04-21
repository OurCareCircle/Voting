//
//  PBAppDelegate.h
//  PollBooth
//
//  Created by iOSDeveloper2 on 05/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLocationManager.h"

@class CLRegion;

@interface PBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) JPLocationManager *jpManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *location;

- (void)startMonitorRegion:(CLRegion*)region;

- (void)sendElapsedTime:(NSDictionary*)timeDict
                 region:(NSString*)identifier;

@end
