//
//  Constant.h
//  ShiftCalendar
//
//  Created by iOSDeveloper2 on 03/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import "WebServiceCalls.h"
#import "PBAppDelegate.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define FacebookAppId @"591120470960430"
static NSString *const kAPIKey = @"AIzaSyB8s6PTMX_whWLjYhWjMVvwW6rKNUW56J4";

//Use this distance for location manager accuracy
static double const  kDistanceAccuracy = 10.0;

//Needed to display ADMOb ads
static NSString *const kAdMobId = @"ca-app-pub-9854808360086090/3950251764";

#define __THEME_COLOR [UIColor colorWithRed:(float)230/255 green:(float)75/255  blue:(float)60/255  alpha:1.0]
#define __THEME_COLOR_DARK [UIColor colorWithRed:(float)24/255 green:(float)26/255  blue:(float)26/255  alpha:1.0]
#define __THEME_COLOR_LIGHT_DARK [UIColor colorWithRed:(float)35/255 green:(float)35/255  blue:(float)31/255  alpha:1.0]

#define __APP_FONT(X)       [UIFont fontWithName:@"HelveticaNeue-Light" size:X]
#define __APP_BOLD_FONT(X)  [UIFont fontWithName:@"AvenirNext-DemiBold" size:X]
#define __APP_DEFAULT_FONT  [UIFont fontWithName:@"HelveticaNeue-Light" size:15]

#define __PUB_PLACEHOLDER_IMAGE     [UIImage imageNamed:@"_pub_logo_holder"]
#define __USER_PLACEHOLDER_IMAGE    [UIImage imageNamed:@"_img_dot"]

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)
#define _COLOR(R,G,B,ALPHA) [[UIColor alloc]initWithRed:(float)R/255 green:(float)G/255 blue:(float)B/255 alpha:ALPHA]

#define UserDefault     [NSUserDefaults standardUserDefaults]
#define DefaultCenter   [NSNotificationCenter defaultCenter]
#define kAppName        @"Poll Booth"
#define __CURRENT_USER  __userInformation[@"iUserID"]

#define _TEST_ 0

static BOOL __testingApp = NO;


static NSString * const kSartTime = @"PBStartTime";
static NSString * const kEndTime  = @"PBEndTime";
static NSString * const kRegion   = @"PBRegion";
static NSString * const kUpFlag   = @"PBUpFlag";

/* global variables */
PBAppDelegate           *__appDelegator;
NSDictionary            *__userInformation;


/* Notifications */
extern NSString* const PBNotificationFoundNewLocation;

/* keys */
extern NSString* const kUserInformationKey;
extern NSString* const kUserLocationKey;
extern NSString* const kUserCurrentPubKey;
extern NSString* const kUserDeviceTokenKey;
// extern NSString* const kPubUsersInfoKey;
extern NSString* const kLastCheckInTime;

/* errors */
extern NSString* const kInternalError;
extern NSString* const kNoRecord;

/* device check */
extern inline bool is_iPhone5();
extern inline bool is_iPad();

/* C functions */
extern inline NSString* NSStringWithoutSpace(NSString* string);
extern inline NSString* NSStringFromCurrentDate(void);
extern inline NSString* NSImageNameStringFromCurrentDate(void);
extern inline NSString* NSStringWithMergeofString(NSString* first,NSString* last);
extern inline NSString* NSStringFullname(NSDictionary* aDict);
extern inline void showAletViewWithMessage(NSString* msg);


