//
//  COMSAppDelegate.h
//  ClassTest
//
//  Created by rafica on 1/31/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COMSAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) NSMutableArray *sharedProperty;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
