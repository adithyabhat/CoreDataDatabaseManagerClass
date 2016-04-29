//
//  ABDatabaseManager.h
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

//This class holds all the boiler plate code of setting up the Core Data persistent store and other components.
//This all provides convinient methods to create child context and save / merge them to main context.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//This is usually your project name
static NSString *managedObjectModelFileName = @"DatabaseManagerSample";

//Update persistentStoreName to change the database file name to be used
static NSString *persistentStoreName = @"DB";

typedef void (^ABDatabaseUpdateSuccessfulCompletionHandler) ();

@interface ABDatabaseManager : NSObject

+ (ABDatabaseManager *)sharedInstance;

@property (readonly, strong, nonatomic) NSOperationQueue *databaseOperationQueue;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

//Creates and returns child managed object context
- (NSManagedObjectContext *)childManagedObjectContext;

//Saves the changes in main context
- (void)saveMainContextWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)databaseUpdatedCompletionHandler;

//Merges the changes in child context to main context and saves the main context
- (void)saveChildContext:(NSManagedObjectContext *)childManagedObjectContext databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;

//Merges the changes from all the child managed contexts and saves the main context
- (void)saveChildContexts:(NSArray *)childManagedObjectContexts databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;

@end
