//
//  AppDelegate.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    else {
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        return managedObjectModel;
    }
}

- (void)deleteModel
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Model.sqlite"]];
    NSError *error = nil;
    [fileManager removeItemAtURL:storeUrl error:&error];
    if (error) {
        NSLog(@"error deleting: %@", error);
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Model.sqlite"]];
    NSLog(@"storeurl: %@", storeUrl);
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)checkForCaretaker:(NSString *)email
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Caretaker" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"error in caretakercheck");
        NSLog(@"%@", error);
        return false;
    } else if (count > 0) {
        return true;
    } else {
        return false;
    }
}

- (void)insertCat
{
    Caretaker *caretaker = [self insertCaretaker:@"cat" withName:@"Cat Twardos"];
}

- (Caretaker *)insertCaretaker:(NSString *)email withName:(NSString *)name
{
    NSLog(@"inserting");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    Caretaker *caretaker = [NSEntityDescription insertNewObjectForEntityForName:@"Caretaker" inManagedObjectContext:context];
    caretaker.email = email;
    caretaker.name = name;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save cat: %@", [error localizedDescription]);
    } else {
        NSLog(@"inserted %@", caretaker.name);
    }
    return caretaker;
}

- (Client *)insertClient:(Caretaker *)caretaker data:(NSMutableDictionary *)data
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    Client *client = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:context];
    for (NSString *key in data) {
        [client setValue:[data valueForKey:key] forKey:key];
    }
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save client: %@", [error localizedDescription]);
        return FALSE;
    }
    client.caretaker = caretaker;
    return client;
}

- (Child *)insertChild:(Client *)parent age:(int)age needs:(NSString *)needs
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    Child *child = [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:context];
    child.age = age;
    child.needs = needs;
    child.parent = parent;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save child: %@", [error localizedDescription]);
    }
    return child;
}

- (BOOL)modifyClient:(Client *)client modify:(NSMutableDictionary *)modify
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSString *key in modify) {
        [client setValue:[modify valueForKey:key] forKey:key];
    }
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save client: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

- (Caretaker *)dbRetrieveCaretaker:(NSString *)email {
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Caretaker" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
    
    NSArray *caretakerArray = [context executeFetchRequest:fetchRequest error:&error];
    if ([caretakerArray count] == 0) {
        return nil;
    } else {
        return (Caretaker *)[caretakerArray lastObject];
    }
}

- (void)dbDeleteClient:(Client *)client
{
    [[self managedObjectContext] deleteObject:client];
}

- (void)deleteAllObjects:(NSString *)entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[[self managedObjectContext] deleteObject:managedObject];
    }
    if (![[self managedObjectContext] save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

@end
