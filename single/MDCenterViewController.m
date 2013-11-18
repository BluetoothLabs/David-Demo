//
//  MDCenterViewController.m
//  single
//
//  Created by Ming-der Wang on 11/16/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "MDCenterViewController.h"
#import "MDAppDelegate.h"

@interface MDCenterViewController ()

@end

@implementation MDCenterViewController

#define kGuard_reference @"kGuard_reference"

extern NSString * const kMDDiscoverPeripheralRSSINotification;//= @"com.katdc.bluetooth.discoverPeripheralRSSI";
extern NSString * const kObjectRSSI;//= @"objectRSSI";

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
    
    MDAppDelegate *app = (MDAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.center = app.BLEcenter;
    
	// Do any additional setup after loading the view.
    // add RSSMeter
//    self.RSSIView.textLabel.text = @"RSSI(-dB)"; // don't use it any more.
    
	self.RSSIView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:18.0];
	self.RSSIView.lineWidth = 2.5;
	self.RSSIView.minorTickLength = 15.0;
	self.RSSIView.needle.width = 3.0;
	self.RSSIView.textLabel.textColor = [UIColor colorWithRed:0.7 green:1.0 blue:1.0 alpha:1.0];
    
	self.RSSIView.value = 50.0;
    
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void) registerNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName: kMDDiscoverPeripheralRSSINotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSDictionary *dict = [notification userInfo];
        NSNumber *rssi = [dict objectForKey:kObjectRSSI];
        
#ifdef DEBUG
        NSLog(@"%s|%@",__PRETTY_FUNCTION__,rssi);
#endif 
        
        self.RSSIView.value = -1 *[rssi floatValue];
        self.value.text = [NSString stringWithFormat: @"RSSI = %2.0f dB", [rssi floatValue]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isOnGaurd= [userDefaults boolForKey:kGuard_reference];
#ifdef DEBUG
    NSLog(@"%s|%d",__PRETTY_FUNCTION__,isOnGaurd);
#endif
    
    if (isOnGaurd) {
        [self.center startScan];
    } else {
        [self.center stopScan];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
