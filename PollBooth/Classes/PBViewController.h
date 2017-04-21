//
//  PBViewController.h
//  PollBooth
//
//  Created by iOSDeveloper2 on 05/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCParentViewController.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface PBViewController : SCParentViewController <GADBannerViewDelegate> {
    GADBannerView *bannerView_;
}
@end
