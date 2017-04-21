//
//  PBViewController.m
//  PollBooth
//
//  Created by iOSDeveloper2 on 05/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import "PBViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "Constant.h"

#define __TestingRadius 50
#define __ActualRadius 250

@interface PBViewController ()<GMSMapViewDelegate,UIActionSheetDelegate> {
    
    GMSMapView          *_mapView;
    IBOutlet UIToolbar  *_toolbar;
    IBOutlet UILabel    *_lblStatus;
    BOOL                loading;
    
    UILongPressGestureRecognizer *_tapGesture;
    UIWebView           *_webView;
    
    
    NSMutableArray *_allCircles;
    
    IBOutlet UISwitch *_testSwitchh;
}

@end


@implementation PBViewController



-(void)dealloc
{
    [DefaultCenter removeObserver:self];
}

-(IBAction)removeAllRegion:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"Remove all monitored regions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:nil, nil];
    [actionsheet setDelegate:self];
    [actionsheet showFromToolbar:_toolbar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self removeAllMoniteredRegions];
    }
}

-(IBAction)testinSwitchValueChange:(id)sender
{
    if(_testSwitchh.isOn)
    {
        __testingApp = YES;
        [self addAllMonitoredRegions];
    }
    else
    {
        __testingApp = NO;
        [self removeAllRegionAnnotation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // __testingApp = YES;
    //dont show nav bar on top; use it only for testing.  Comment below while testing
    self.navigationController.navigationBar.hidden = YES;
    
    _allCircles  = [[NSMutableArray alloc]init];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    [_lblStatus setText:@"Longpress on map to find Poll Booths"];
    
    [DefaultCenter addObserver:self
                      selector:@selector(didFindNewLocation:)
                          name:PBNotificationFoundNewLocation
                        object:nil];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.000
                                                            longitude:0.000
                                                                 zoom:1];
    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [_mapView setMyLocationEnabled:YES];
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:_toolbar];
    [self.view bringSubviewToFront:_lblStatus];
    _tapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnMap:)];
    [_tapGesture setMinimumPressDuration:1];
    _mapView.userInteractionEnabled = YES;
    [_mapView removeGestureRecognizer:_mapView.gestureRecognizers[0]];
    [_mapView addGestureRecognizer:_tapGesture];

//    // removes all monitored regions
//     [self removeAllMoniteredRegions];
    
//    if(__testingApp)
//        [self addAllMonitoredRegions];
    
    //Place ad at top of view
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = kAdMobId;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    GADRequest  *request = [GADRequest request];
    //request.testDevices = [NSArray arrayWithObjects:@"5f7bb68b9b15b78e1628d53583b1af61", nil]; //needed for testing on my iphone5
    //request.testing     = YES;
    [bannerView_ loadRequest:request];
    [bannerView_ setDelegate:self];
    [self.view bringSubviewToFront:bannerView_];
}

//Admob delegates
- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  20.0,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
    NSLog(@"Did receive ad");
}


-(void)addAllMonitoredRegions
{
    NSArray *regions =  [[__appDelegator.jpManager.locationManager monitoredRegions]allObjects];
    [regions enumerateObjectsUsingBlock:^(CLRegion *obj, NSUInteger idx, BOOL *stop)
    {
        GMSCircle *circle = [GMSCircle new];
        circle.position     = obj.center;
        circle.radius       = obj.radius;
        circle.strokeColor  = [UIColor blueColor];
        circle.fillColor    = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circle.map          = _mapView;
        [_allCircles addObject:circle];
    }];
}

-(void)removeAllRegionAnnotation
{
    [_allCircles enumerateObjectsUsingBlock:^(GMSCircle *obj, NSUInteger idx, BOOL *stop) {
        obj.map = nil;
    }];
    [_allCircles removeAllObjects];
}

-(void)removeAllMoniteredRegions
{
    NSArray *regions =  [[__appDelegator.jpManager.locationManager monitoredRegions]allObjects];
    [regions enumerateObjectsUsingBlock:^(CLRegion *obj, NSUInteger idx, BOOL *stop)
     {
         [__appDelegator.jpManager.locationManager stopMonitoringForRegion:obj];
     }];
    
    [_allCircles enumerateObjectsUsingBlock:^(GMSCircle *obj, NSUInteger idx, BOOL *stop) {
        obj.map = nil;
    }];
    
    [_allCircles removeAllObjects];
}

-(void)testingRegions:(CLLocationCoordinate2D)location
{
    CLRegion* region;
    if(IsAtLeastiOSVersion(@"7.0"))
        region = [[CLCircularRegion alloc] initCircularRegionWithCenter:location
                                                                 radius:__TestingRadius
                                                             identifier:[NSString stringWithFormat:@"%f, %f", location.latitude, location.longitude]];
    else
        region = [[CLRegion alloc] initCircularRegionWithCenter:location
                                                         radius:__TestingRadius
                                                     identifier:[NSString stringWithFormat:@"%f, %f", location.latitude, location.longitude]];
    
//    [UserDefault setObject:@{ kSartTime : [NSDate date],
//                              kUpFlag   : @(0) ,
//                              kRegion   : [NSString stringWithFormat:@"%f,%f",
//                                           region.center.latitude,region.center.longitude] }
//                    forKey:region.identifier];
//    [UserDefault synchronize];
//    
//    NSDictionary *timeDict              = [UserDefault objectForKey:region.identifier];
//    NSMutableDictionary *mutTimeDict    = [timeDict mutableCopy];
//    mutTimeDict[kEndTime]               = [[NSDate date] dateByAddingTimeInterval:30*60];
//    mutTimeDict[kUpFlag]                =  @(1);
//    [UserDefault setObject:mutTimeDict forKey:region.identifier];
//    [UserDefault synchronize];
    
//    [UserDefault setObject:@{ kSartTime:[NSDate date] }
//                    forKey:@"Test123"];
//    [UserDefault synchronize];
//    
//    NSDictionary *timeDict = [UserDefault objectForKey:@"Test123"];
//        NSMutableDictionary *mutTimeDict = [timeDict mutableCopy];
//    mutTimeDict[kEndTime] = [[NSDate date] dateByAddingTimeInterval:60*60*2];
//    [UserDefault setObject:mutTimeDict forKey:@"Test123"];
//    [UserDefault synchronize];
//    [self sendElapsedTime:mutTimeDict region:region];
    
     [__appDelegator startMonitorRegion:region];
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    CLRegion* region;
    if(IsAtLeastiOSVersion(@"7.0"))
        region = [[CLCircularRegion alloc] initCircularRegionWithCenter:marker.position
                                                                 radius:__ActualRadius
                                                             identifier:marker.snippet];
    else
        region = [[CLRegion alloc]initCircularRegionWithCenter:marker.position
                                                        radius:__ActualRadius
                                                    identifier:marker.snippet];
    [__appDelegator startMonitorRegion:region];
    
    return NO;
}

- (void)tapOnMap:(UITapGestureRecognizer*)recongnizer
{
    if(recongnizer.state != UIGestureRecognizerStateBegan)
        return;
    if(loading == YES)
        return;
    
    [self showIndicator];
    
    CGPoint point = [recongnizer locationInView:recongnizer.view];
    
    CLLocationCoordinate2D locationPoint = [_mapView.projection coordinateForPoint:point];
    if(__testingApp)
    {
        GMSCircle *circle = [GMSCircle new];
        circle.position     = locationPoint;
        circle.radius       = __TestingRadius;
        circle.strokeColor  = [UIColor blueColor];
        circle.fillColor    = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circle.map          = _mapView;
        
        [_allCircles addObject:circle];
        [self testingRegions:locationPoint];
        [self hideIndicator];
        return;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationPoint.latitude
                                                            longitude:locationPoint.longitude
                                                                 zoom:10];
    [_mapView animateToCameraPosition:camera];
    
    GMSCircle *circle   = [GMSCircle new];
    circle.position     = locationPoint;
    circle.radius       = 9000;
    circle.strokeColor  = [UIColor redColor];
    circle.fillColor    = [[UIColor redColor] colorWithAlphaComponent:0.1];
    circle.map          = _mapView;
    
    [WebServiceCalls findNearBoothsFromLocation:locationPoint
                                         radius:5
                                completionBlock:^(id JSON, WebServiceResult result)
     {
         if(result == WebServiceResultSuccess)
         {
             NSLog(@"polls : %@",JSON);
             if([JSON count])
             {
                 [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                  {
                      CLLocationCoordinate2D locationPoint;
                      locationPoint.latitude   = [obj[@"latitude"] doubleValue];
                      locationPoint.longitude  = [obj[@"longitude"] doubleValue];
                      
                      [WebServiceCalls fetchWaitTimeOnCoordinate:locationPoint
                                                           block:^(id string, WebServiceResult result)
                       {
                           GMSMarker *marker = [[GMSMarker alloc]init];
                           marker.position = locationPoint;
                           marker.map = _mapView;
                           marker.userData = obj;
                           NSString *htmlString  = [obj[@"infohtml"] gtm_stringByUnescapingFromHTML];
                           NSString *plainString = [htmlString stringByConvertingHTMLToPlainText];
                           NSString *nameAndNo   = [plainString componentsSeparatedByString:@"NO and Name :"][1];
                           marker.snippet = [nameAndNo componentsSeparatedByString:@"Name:"][0];
                           
                           if(result == WebServiceResultSuccess)
                           {
                               //remove the string \n and space from result string
                               string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                               string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                               string = [string stringByReplacingOccurrencesOfString:@" "   withString:@""];
                               
                               float wait = [string floatValue];
                               
                               if(wait>60)
                               {
                                   marker.icon = [UIImage imageNamed:@"redPin"];
                               }
                               else if (wait<60 && wait>30)
                               {
                                   marker.icon = [UIImage imageNamed:@"yellowPin"];
                               }
                               else if(wait<30)
                               {
                                   marker.icon = [UIImage imageNamed:@"greenPin"];
                               }
                           }
                           
                           if(idx == [JSON count]-1)
                           {
                               [self hideIndicator];
                               circle.strokeColor   = [[UIColor redColor] colorWithAlphaComponent:0.2];
                               circle.fillColor     = [UIColor clearColor];
                           }
                       }];
                  }];
             }
             else {
                 [self hideIndicator];
                 circle.strokeColor   = [[UIColor redColor] colorWithAlphaComponent:0.2];
                 circle.fillColor     = [UIColor clearColor];
             }
         }
     }];
    
    
}

-(void)showIndicator
{
    [self showSmartHud];
    [_lblStatus setText:@"Looking for poll booths...."];
    loading = YES;
}

-(void)hideIndicator
{
    [self hideSmartHud];
    [_lblStatus setText:@"Longpress on map to find Poll Booth"];
    loading = NO;
}


- (void)didFindNewLocation:(NSNotification*)notification
{
    CLLocation *userLocation  = [notification object];
    if(!__appDelegator.location)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userLocation.coordinate.latitude
                                                                longitude:userLocation.coordinate.longitude
                                                                     zoom:15];
        [_mapView animateToCameraPosition:camera];
    }
    __appDelegator.location = userLocation;

    NSString *urlString = [NSString stringWithFormat:@"http://54.179.7.238/maps/geofence.php?opcode=fetch&lat=%.08f&lng=%.08f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    NSLog(@"----> %@",urlString);
}

//{
//    infohtml = "&lt;div align=left&gt;   State/UT Name:&lt;b&gt;Karnataka&lt;/b&gt;&lt;br&gt;CEO Name:&lt;b&gt;Anil Kumar Jha, Ph : 9448290830&lt;/b&gt;&lt;br&gt;District No and Name :&lt;b&gt;32-B.B.M.P(NORTH)&lt;/b&gt;&lt;br&gt;DEO Name:&lt;b&gt;Umananda Rai, Ph : 9480684555&lt;/b&gt;&lt;br&gt;AC No and Name :&lt;b&gt;157-Malleshwaram&lt;/b&gt;&lt;br&gt;ERO Name:&lt;b&gt;D.K. Babau, Ph : 9480684353&lt;/b&gt;&lt;br&gt;PS NO and Name : &lt;b&gt;91-Himamshu Jyothi Kalapeeta, Room No -02&lt;/b&gt;&lt;br&gt;BLO Name:&lt;b&gt;, Ph : &lt;/b&gt;&lt;br/&gt;&lt;br/&gt;&lt;/div&gt;";
//    latitude = "13.00631905";
//    longitude = "77.56841278";
//},


@end
