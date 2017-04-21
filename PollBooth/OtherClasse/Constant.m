//
//  Constant.m
//  ShiftCalendar
//
//  Created by iOSDeveloper2 on 03/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.
//

#import "Constant.h"



NSString* const PBNotificationFoundNewLocation = @"Found new location";


NSString* const kInternalError      = @"Some internal error occured";
NSString* const kNoRecord           = @"No record found";
NSString* const kUserCurrentPubKey  = @"CurrentPubKey";
// NSString* const kPubUsersInfoKey    = @"PubUsersInformation";
NSString* const kLastCheckInTime    = @"LastCheckInTime";
NSString* const kUserDeviceTokenKey = @"UserDeviceTokenKey";
NSString* const kUserInformationKey = @"UserInformationDictionaryKey";
NSString* const kUserLocationKey    = @"UserCurrentLocationKey";


inline bool is_iPhone5()
{
    if ([[UIScreen mainScreen] bounds].size.height==568)
        return YES;
    else
        return NO;
}

inline bool is_iPad()
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
}

inline NSString* NSStringWithoutSpace(NSString* string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

inline NSString* NSStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

inline NSString* NSImageNameStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    return imageName;
}

inline NSString* NSStringWithMergeofString(NSString* first,NSString* last)
{
    return [NSString stringWithFormat:@"%@ %@",first,last];
}

inline NSString* NSStringFullname(NSDictionary* aDict)
{
    if(!aDict[@"vLastName"] || ![aDict[@"vLastName"] length])
        return aDict[@"vFirstName"];
    else
        return [NSString stringWithFormat:@"%@ %@",aDict[@"vFirstName"],aDict[@"vLastName"]];
}

inline void showAletViewWithMessage(NSString* msg)
{
  //  if(_TEST_){
    UIAlertView *alert123 = [[UIAlertView alloc]initWithTitle:nil
                                          message:msg
                                         delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"kDismiss", nil)
                                otherButtonTitles:nil, nil];
    [alert123 show];
 //   }
}

