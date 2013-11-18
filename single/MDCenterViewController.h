//
//  MDCenterViewController.h
//  single
//
//  Created by Ming-der Wang on 11/16/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeterView.h"
#import "MDBlueToothCenter.h"

@interface MDCenterViewController : UIViewController

@property (nonatomic, retain) IBOutlet MeterView *RSSIView;
@property (nonatomic, retain) MDBlueToothCenter *center;
@property (nonatomic, retain) IBOutlet UILabel *value;

@end
