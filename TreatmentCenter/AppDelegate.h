//
//  AppDelegate.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Client.h"
#import "AppDelegate.h"
#import "Caretaker.h"
#import "Child.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)checkForCaretaker:(NSString *)email;
- (void)insertCat;
- (Caretaker *)insertCaretaker:(NSString *)email withName:(NSString *)name;
//Change the below to use dictionary
- (Client *)insertClient:(Caretaker *)caretaker data:(NSMutableDictionary *)data;
- (BOOL)modifyClient:(Client *)client modify:(NSMutableDictionary *)modify;
- (Child *)insertChild:(Client *)parent age:(int)age needs:(NSString *)needs;
- (Caretaker *)dbRetrieveCaretaker:(NSString *)email;
- (void)dbDeleteClient:(Client *)client;
- (void)deleteAllObjects:(NSString *)entityDescription;
- (void)deleteModel;

@end
