//
//  SCParentViewController.h
//  ShiftCalendar
//
//  Created by iOSDeveloper2 on 07/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#define __ThresholdPoint 260


@interface SCParentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet UITableView *tableView;

-(void)showHud;
-(void)hideHud;

-(void)showSmartHud;
-(void)hideSmartHud;


-(IBAction)parentBackAction:(id)sender;
-(IBAction)parentRootBackAction:(id)sender;
-(IBAction)parentDismissAction:(id)sender;


@end
