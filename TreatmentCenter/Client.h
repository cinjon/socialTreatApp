//
//  Client.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caretaker, Child;

@interface Client : NSManagedObject

@property (nonatomic, retain) NSString * activePsych;
@property (nonatomic) BOOL arson;
@property (nonatomic, retain) NSString * axisOne;
@property (nonatomic, retain) NSString * axisTwo;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic) BOOL childWelfare;
@property (nonatomic) BOOL detox;
@property (nonatomic) BOOL dv;
@property (nonatomic) BOOL employed;
@property (nonatomic) BOOL felonyBool;
@property (nonatomic, retain) NSString * felonyDesc;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic) BOOL mentalBool;
@property (nonatomic) BOOL methadone;
@property (nonatomic) BOOL hasChild;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic) BOOL pregnant;
@property (nonatomic, retain) NSString * residentialOutpatient;
@property (nonatomic) BOOL t90;
@property (nonatomic) BOOL h5150;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * insurance;
@property (nonatomic) BOOL english;
@property (nonatomic, retain) Caretaker *caretaker;
@property (nonatomic, retain) NSMutableArray *children;

@end

@interface Client (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Child *)value;
- (void)removeChildrenObject:(Child *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
