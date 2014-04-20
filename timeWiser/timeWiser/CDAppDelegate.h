//
//  CDAppDelegate.h
//  timeWiser
//
//  Created by Liu Zhe on 3/30/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModal;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
