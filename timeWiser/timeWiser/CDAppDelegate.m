//
//  CDAppDelegate.m
//  timeWiser
//
//  Created by Liu Zhe on 3/30/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDAppDelegate.h"
#import "BlurryModalSegue.h"

@implementation CDAppDelegate
{
    NSMutableArray *objects;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModal = _managedObjectModal;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Failed to load persistent store: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModal != nil) {
        return _managedObjectModal;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"tasks" withExtension:@"momd"];
    _managedObjectModal = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModal;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tasks.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isSelected"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isEmpty"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isEmpty"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"minutes"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:0] forKey:@"minutes"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"hours"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:0] forKey:@"hours"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"title"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"title"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"detail"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"detail"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isInProgress"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isInProgress"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"taskID"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"running"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"running"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isTerminated"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isTerminated"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"timeLeft"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:0] forKey:@"timeLeft"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"endDate"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"endDate"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"activeDate"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"activeDate"];
    }
    //NSLog(@"did finish launching");
    //if the task is completed while the application is terminated
    if (application.applicationIconBadgeNumber != 0)
    {
        //NSString *taskTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
        //[self showAlertWithTitle:taskTitle];
        //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"running"];
        //NSLog(@"I have fired a local notification");
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isTerminated"] boolValue] == YES)
        {
            [self showAlertWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"title"]];
            NSManagedObjectContext *context = [self managedObjectContext];
            NSData *idData = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"];
            NSURL *idURL = [NSKeyedUnarchiver unarchiveObjectWithData:idData];
            NSManagedObjectID *objectID = [[context persistentStoreCoordinator] managedObjectIDForURIRepresentation:idURL];
            [self completeTaskWithID:objectID];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isTerminated"];
        }
    }
    //implement handler to handle situation when task is not completed after reentering the app from an terminated state and the
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"activeDate"];
        //NSLog(@"no notification");
        //NSLog(@"time left = %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"timeLeft"] intValue]);
    }
    // Override point for customization after application launch.
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(8)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(1.0)];
    [[BlurryModalSegue appearance] setBackingImageTintColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.45]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //NSLog(@"did receive local notification");
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    NSString *taskTitle = [notification.userInfo objectForKey:@"title"];
    [self showAlertWithTitle:taskTitle];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"running"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isTerminated"] boolValue] == YES)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSData *idData = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"];
        NSURL *idURL = [NSKeyedUnarchiver unarchiveObjectWithData:idData];
        NSManagedObjectID *objectID = [[context persistentStoreCoordinator] managedObjectIDForURIRepresentation:idURL];
        [self completeTaskWithID:objectID];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isTerminated"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!" message:[NSString stringWithFormat:@"%@ is completed!",title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)completeTaskWithID:(NSManagedObjectID *)objectID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isInProgress"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"running"];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *completetTask = [context objectWithID:objectID];
    [completetTask setValue:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
    NSDate *completeDate = [NSDate date];
    [completetTask setValue:completeDate forKey:@"completeDate"];
    NSError *error = nil;
    [context save:&error];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *isCompleted = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
    [request setPredicate:isCompleted];
    if (!objects)
    {
        objects = [[NSMutableArray alloc] init];
    }
    [objects removeAllObjects];
    [objects addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    if ([objects count] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isEmpty"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[objects objectAtIndex:[objects count] - 1] valueForKey:@"title"] forKey:@"title"];
        [[NSUserDefaults standardUserDefaults] setObject:[[objects objectAtIndex:[objects count] - 1] valueForKey:@"details"] forKey:@"detail"];
        [[NSUserDefaults standardUserDefaults] setObject:[[objects objectAtIndex:[objects count] - 1] valueForKey:@"minutes"] forKey:@"minutes"];
        [[NSUserDefaults standardUserDefaults] setObject:[[objects objectAtIndex:[objects count] - 1] valueForKey:@"hours"] forKey:@"hours"];
        NSManagedObjectID *objectID = [[objects objectAtIndex:[objects count] - 1] objectID];
        NSURL *url = [objectID URIRepresentation];
        NSData *urlData = [NSKeyedArchiver archivedDataWithRootObject:url];
        [[NSUserDefaults standardUserDefaults] setObject:urlData forKey:@"taskID"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taskComplete" object:self];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"goingToBackground" object:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"endDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isInProgress"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"did become active");
    if (application.applicationIconBadgeNumber != 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"taskComplete" object:self];
    }
    [application cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //NSLog(@"will terminate");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"taskTerminated" object:self];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isInProgress"] boolValue] == YES)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isTerminated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isInProgress"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"running"];
}

@end
