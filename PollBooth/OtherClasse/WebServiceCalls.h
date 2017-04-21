//
//  WebServiceCalls.h
//  Ponder_remake
//
//  Created by Yudiz Solutions on 04/07/13.
//  Copyright (c) 2013 Yudiz Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://isa-nu.org/noa/ws/login?vUsername=dhavalY&vPassword=db1234

#define kBasePath @"http://54.179.7.238/maps"

typedef NS_ENUM (NSInteger, WebServiceResult)
{
    WebServiceResultSuccess = 0,
    WebServiceResultFail,
    WebServiceResultError
};

typedef NS_ENUM (NSInteger, NMVisibility)
{
    NMVisibilityAll = 0,
    NMVisibilityFriend,
    NMVisibilityNone,
};

typedef void(^WebCallBlock)(id JSON,WebServiceResult result);




@interface WebServiceCalls : NSObject


//54.179.7.238/maps/booths.php?lat=13.003&lng=77.567734&radius=5
+(void)findNearBoothsFromLocation:(CLLocationCoordinate2D)location
                           radius:(int)redius
                  completionBlock:(WebCallBlock)block;

//54.179.7.238/maps/geofence.php?opcode=exit&lat=xxx&lng=yyy&elapsed=www
+(void)sendElapsedTime:(long)elapsedTime
          onCoordinate:(CLLocationCoordinate2D)location
                 block:(WebCallBlock)block;

//54.179.7.238/maps/geofence.php?opcode=fetch&lat=xxx&lng=yyy
+(void)fetchWaitTimeOnCoordinate:(CLLocationCoordinate2D)location
                           block:(WebCallBlock)block;




@end


