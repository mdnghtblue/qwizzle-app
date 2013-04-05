//
//  QWZAppDelegate.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

////////////////////////////
// Objects for Core Data
// The bridge between application interface and the managed object model
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// The database's schema
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// The bridge between the physical file that stores our data and our application
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext; // Initiate saving all data inside the context
- (NSURL *)applicationDocumentsDirectory; // Getting application directory that saves all the database file

@end
