//
//  Organization.h
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 10.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employe;

@interface Organization : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *employers;
@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addEmployersObject:(Employe *)value;
- (void)removeEmployersObject:(Employe *)value;
- (void)addEmployers:(NSSet *)values;
- (void)removeEmployers:(NSSet *)values;

@end
