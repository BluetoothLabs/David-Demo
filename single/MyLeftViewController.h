//
//  MyLeftViewController.h
//  single
//
//  Created by Wang Ming-der on 5/11/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLeftViewController : UITableViewController {
    IBOutlet UIButton *buttonToCenter;
	NSMutableArray *itemArray;
}
@property (nonatomic, retain) NSMutableArray *itemArray;

- (IBAction)showCenter:(id)sender;

@end
