//
//  ABDatabaseManager.h
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString *managedObjectModelFileName = @"DatabaseManagerSample";
static NSString *persistentStoreName = @"DB";

typedef void (^ABDatabaseUpdateSuccessfulCompletionHandler) ();

@interface ABDatabaseManager : NSObject

+ (ABDatabaseManager *)sharedInstance;

@property (readonly, strong, nonatomic) NSOperationQueue *databaseOperationQueue;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext *)childManagedObjectContext;

//Saves the main context
- (void)saveMainContextWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)databaseUpdatedCompletionHandler;
- (void)saveChildContext:(NSManagedObjectContext *)childManagedObjectContext databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;
- (void)saveChildContexts:(NSArray *)childManagedObjectContentexts databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;

@end
