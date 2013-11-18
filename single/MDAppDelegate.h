//
//  MDAppDelegate.h
//  single
//
//  Created by Wang Ming-der on 5/11/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Example.h"
#import "MDBlueToothCenter.h"

@interface MDAppDelegate : UIResponder <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MDBlueToothCenter *BLEcenter;

@end
