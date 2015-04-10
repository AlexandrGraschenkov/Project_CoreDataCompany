//
//  Employe.h
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 10.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Organization;

@interface Employe : NSManagedObject

@property (nonatomic, retain) id avatar;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) Organization *organization;

@end
