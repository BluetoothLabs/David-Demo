//
//  MySettingsViewController.m
//  single
//
//  Created by Wang Ming-der on 5/15/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "MySettingsViewController.h"

@interface MySettingsViewController ()

@end

@implementation MySettingsViewController

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
	// Do any additional setup after loading the view.
    NSString *firmwareVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [[NSUserDefaults standardUserDefaults] setValue:firmwareVersion forKey:@"version_preference"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exit:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
