//
//  MDCenterViewController.m
//  single
//
//  Created by Ming-der Wang on 11/16/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "MDCenterViewController.h"
#import "MDAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MDBlueToothCenter.h"

@interface MDCenterViewController ()

@end

@implementation MDCenterViewController

#define kGuard_reference @"kGuard_reference"
#define kSlider_reference @"slider_reference"

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
        BOOL alarm = [[MDBlueToothCenter getDefaultInstance] isAlarmOn] ;
        
    
        
        float scale = ((-1.f *[rssi floatValue]) -35.f) * (100.f/65.f);
        self.RSSIView.value = scale;
        if(self.RSSIView.value < 0) {
            self.RSSIView.value = 0.f;
        }
        if(self.RSSIView.value >100) {
            self.RSSIView.value = 100.f;
        }
        if (alarm && scale >= max) {
            AudioServicesPlaySystemSound(1005);
        }
#ifdef DEBUG
//        NSLog(@"%s|%f",__PRETTY_FUNCTION__,scale);
#endif
        
        
        self.value.text = [NSString stringWithFormat: @"RSSI = %2.0f dB (%d)", [rssi floatValue], max];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isOnGaurd= [userDefaults boolForKey:kGuard_reference];
#ifdef DEBUG
    NSLog(@"%s|%d",__PRETTY_FUNCTION__,isOnGaurd);
#endif
    
    max = [userDefaults integerForKey:kSlider_reference];
#ifdef DEBUG
    NSLog(@"%s|%d",__PRETTY_FUNCTION__,max);
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
