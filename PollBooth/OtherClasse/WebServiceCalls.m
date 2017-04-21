//
//  WebServiceCalls.m
//  Ponder_remake
//
//  Created by Yudiz Solutions on 04/07/13.
//  Copyright (c) 2013 Yudiz Solutions. All rights reserved.
//

#import "WebServiceCalls.h"
#import "AFNetworking.h"
#import "PBPollBoothParser.h"
#import "PBWaitTimeParser.h"

static AFHTTPRequestOperationManager *manager;

@interface WebServiceCalls()

+(void)simpleGetMethodWithRelativePath:(NSString*)relativePath
                             paramater:(NSDictionary*)param
                                 block:(WebCallBlock)block;

@end


@implementation WebServiceCalls


+ (void)initialize
{
    manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kBasePath]];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
}

+ (void)simpleGetMethodWithRelativePath:(NSString*)relativePath
                              paramater:(NSDictionary*)param
                                  block:(WebCallBlock)block
{
    NSLog(@"realtivePath: %@",relativePath);
    NSLog(@"paramaters : %@",param);
    
    [manager GET:relativePath
      parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response : %@",responseObject);
         [PBPollBoothParser parseXML:responseObject completionblock:^(id obj, BOOL success)
         {
              block(obj,WebServiceResultSuccess);
         }];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         showAletViewWithMessage(error.localizedDescription);
         block(error,WebServiceResultError);
         NSLog(@"Operation: %@",operation);
         NSLog(@"Error : %@",error);
     }];
}


#pragma mark -

//54.179.7.238/maps/booths.php?lat=13.003&lng=77.567734&radius=5
+(void)findNearBoothsFromLocation:(CLLocationCoordinate2D)location
                           radius:(int)redius
                  completionBlock:(WebCallBlock)block
{
    NSLog(@"--------- fetching booth WS Called --------");
    [manager GET:@"booths.php"
      parameters:@{ @"lat"      :@(location.latitude),
                    @"lng"      :@(location.longitude),
                    @"radius"   :@(5) }
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response : %@",responseObject);
         [PBPollBoothParser parseXML:responseObject completionblock:^(id obj, BOOL success)
          {
              block(obj,WebServiceResultSuccess);
          }];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         showAletViewWithMessage(error.localizedDescription);
         block(error,WebServiceResultError);
         NSLog(@"Operation: %@",operation);
         NSLog(@"Error : %@",error);
     }];
}


// latitude = "13.00631905";
// longitude = "77.56841278";
// 54.179.7.238/maps/geofence.php?opcode=exit&lat=xxx&lng=yyy&elapsed=www

+(void)sendElapsedTime:(long)elapsedTime
          onCoordinate:(CLLocationCoordinate2D)location
                 block:(WebCallBlock)block
{
    NSLog(@"--------- Wait time WS Called --------");
    NSString *urlString = [NSString stringWithFormat:@"http://54.179.7.238/maps/geofence.php?opcode=exit&lat=%.08f&lng=%.08f&elapsed=%ld",location.latitude,location.longitude,elapsedTime];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
//    /* sending request by post method*/
//    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
//    [request1 setHTTPMethod:@"POST"];
//    [request1 setURL:[NSURL URLWithString:@"http://54.179.7.238/maps/geofence.php"]];
//    NSDictionary *param = @{ @"opcode"   : @"exit",
//                             @"lat"      : @(location.latitude),
//                             @"lng"      : @(location.longitude),
//                             @"elapsed"  : @(elapsedTime) };
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    [request1 setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
//    [request1 setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:0 error:nil]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if(connectionError)
             block(connectionError,WebServiceResultError);
         NSString *waitingTime = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"Waiting time in text : %@",waitingTime);
         NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
         [PBWaitTimeParser parseXML:parser completionblock:^(id obj, BOOL success)
          {
              if(success)
                  block(obj,WebServiceResultSuccess);
              else
                  block(nil,WebServiceResultFail);
          }];
     }];
    
}


//54.179.7.238/maps/geofence.php?opcode=fetch&lat=22.97464561&lng=73.19805908
+(void)fetchWaitTimeOnCoordinate:(CLLocationCoordinate2D)location
                           block:(WebCallBlock)block
{
    NSLog(@"--------- Wait time WS Called --------");
    NSString *urlString = [NSString stringWithFormat:@"http://54.179.7.238/maps/geofence.php?opcode=fetch&lat=%.08f&lng=%.08f",location.latitude,location.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
//    /* sending request by post method */
//    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
//    [request1 setHTTPMethod:@"POST"];
//    [request1 setURL:[NSURL URLWithString:@"http://54.179.7.238/maps/geofence.php"]];
//    NSDictionary *param = @{ @"opcode"   : @"fetch",
//                             @"lat"      : @(location.latitude),
//                             @"lng"      : @(location.longitude) };
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    [request1 setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
//    [request1 setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:0 error:nil]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if(connectionError)
            block(connectionError,WebServiceResultError);
        NSString *waitingTime = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Waiting time in text : %@",waitingTime);
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        [PBWaitTimeParser parseXML:parser completionblock:^(id obj, BOOL success)
        {
            if(success)
                block(obj,WebServiceResultSuccess);
            else
                block(nil,WebServiceResultFail);
        }];
    }];
    
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:@"geofence.php"
//      parameters:@{ @"lat"      :@(location.latitude),
//                    @"lng"      :@(location.longitude),
//                    @"opcode"   :@"fetch" }
//         success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"Response : %@",responseObject);
////         [PBPollBoothParser parseXML:responseObject completionblock:^(id obj, BOOL success)
////          {
////              block(obj,WebServiceResultSuccess);
////          }];
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         showAletViewWithMessage(error.localizedDescription);
//         block(error,WebServiceResultError);
//         NSLog(@"Operation: %@",operation);
//         NSLog(@"Error : %@",error);
//     }];
}

@end






