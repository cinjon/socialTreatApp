//
//  Caretaker.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client;

@interface Caretaker : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableArray *clients;
@end

@interface Caretaker (CoreDataGeneratedAccessors)

- (void)insertObject:(Client *)value inClientsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromClientsAtIndex:(NSUInteger)idx;
- (void)insertClients:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeClientsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInClientsAtIndex:(NSUInteger)idx withObject:(Client *)value;
- (void)replaceClientsAtIndexes:(NSIndexSet *)indexes withClients:(NSArray *)values;
- (void)addClientsObject:(Client *)value;
- (void)removeClientsObject:(Client *)value;
- (void)addClients:(NSOrderedSet *)values;
- (void)removeClients:(NSOrderedSet *)values;
@end
