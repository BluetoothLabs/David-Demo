//
//  MyLeftViewController.m
//  single
//
//  Created by Wang Ming-der on 5/11/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "MyLeftViewController.h"
#import "MDAppDelegate.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@implementation MyLeftViewController
@synthesize itemArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initListItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)showCenter:(id)sender {
    // sweet, I can access my parent JASidePanelController as a property!
    [self.sidePanelController showCenterPanelAnimated:YES];
    
}

#pragma mark - list of items

- (void) initListItems {
    MDAppDelegate *app = (MDAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.itemArray = [NSMutableArray arrayWithArray:app.itemArray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyExampleTableCell";
    
    UITableViewCell *cell = [self.tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType=UITableViewCellAccessoryNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    Example *cellValue = [itemArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = cellValue.item;
    
    return cell;
}
@end
