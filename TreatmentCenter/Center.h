//
//  Center.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/24/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Center : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * location;

@end
