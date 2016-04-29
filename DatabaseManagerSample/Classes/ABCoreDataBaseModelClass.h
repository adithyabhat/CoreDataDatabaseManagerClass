//
//  ABCoreDataBaseModelClass.h
//  DatabaseManagerSample
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

//This is a abstract class which should be the parent class for all the nsmanagedobject model classes.

#import <CoreData/CoreData.h>
#import "ABDatabaseManager.h"

@interface ABCoreDataBaseModelClass : NSManagedObject

//The entity name used for the ManagedObjectContext. By default class name is taken as entityName.
+ (NSString *)entityName;

//This is the primary key, based on which searching is done.
+ (NSString *)identifierParameter;

//Creates new instance of the managedObject
+ (instancetype)newInstanceInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//Checks if the instance is already avaialble in the database for the provided identifier in the corresponding managedobjectcontext,
//if not then new object is created and returned, else already existing object is returned.
//isNewlyCreated property will indicate if the object was newly created or already existed.
+ (instancetype)instanceWithId:(id)identifier
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                isNewlyCreated:(BOOL *)isNewlyCreated;

//Saves the managedobject to the database in a thread safe way.
- (void)saveWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;

@end
