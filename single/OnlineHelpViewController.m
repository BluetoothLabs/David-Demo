//
//  OnlineHelpViewController.m
//  single
//
//  Created by Wang Ming-der on 5/17/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "OnlineHelpViewController.h"

@interface OnlineHelpViewController ()

@end

@implementation OnlineHelpViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    NSString *urlAddress =[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //Create a URL object.
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    webView = nil;
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
