//
//  SCParentViewController.m
//  ShiftCalendar
//
//  Created by iOSDeveloper2 on 07/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.
//

#import "SCParentViewController.h"

@interface SCParentViewController () <UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView     *_actInd;
    UILabel                     *_lblProgress;
    UIActivityIndicatorView     *_smartActInd;
}

@end


@implementation SCParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IsAtLeastiOSVersion(@"7.0")){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    _lblProgress = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_lblProgress setText:@""];
    [_lblProgress setBackgroundColor:[UIColor darkGrayColor]];
    [_lblProgress setAlpha:1];
    [_lblProgress.layer setCornerRadius:5];
    [_lblProgress setCenter:self.view.center];
    
    // [_lblProgress.layer setBorderWidth:1.0];
    // [_lblProgress.layer setBorderColor:[UIColor whiteColor].CGColor];
    // self.interactivePopGestureRecognizer.delegate = weakSelf;
    // [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(handleGesture:)];
    // self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    _actInd  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_actInd setCenter:self.view.center];
    
    _smartActInd = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_smartActInd setFrame:CGRectMake(self.view.frame.size.width-35,self.view.frame.size.height-32, 20, 20)];
    [_smartActInd setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
}

-(void)showHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.view addSubview:_lblProgress];
    [self.view addSubview:_actInd];
    [_actInd  startAnimating];
    [self.view setAlpha:0.95];
    [self.view setUserInteractionEnabled:NO];
}

-(void)hideHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_lblProgress removeFromSuperview];
    [_actInd removeFromSuperview];
    [_actInd stopAnimating];
     [self.view setAlpha:1.0];
    [self.view setUserInteractionEnabled:YES];
}

-(void)showSmartHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.view addSubview:_smartActInd];
    [_smartActInd  startAnimating];
}

-(void)hideSmartHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_smartActInd removeFromSuperview];
    [_smartActInd stopAnimating];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}


#pragma mark - IBActions

-(IBAction)parentBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)parentDismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)parentRootBackAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
