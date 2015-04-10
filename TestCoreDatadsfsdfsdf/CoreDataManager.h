//
//  CoreDataManager.h
//  Test_CoreData
//
//  Created by Alexander on 18.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Organization.h"
#import "Employe.h"
#import "Employe+Ex.h"

@interface CoreDataManager : NSObject

+ (instancetype)shared;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext *)getContextForCurrentQueue;

@end
