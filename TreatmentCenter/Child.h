//
//  Child.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client;

@interface Child : NSManagedObject

@property (nonatomic) int16_t age;
@property (nonatomic, retain) NSString * needs;
@property (nonatomic, retain) Client *parent;

@end
