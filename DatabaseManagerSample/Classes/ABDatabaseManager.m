//
//  ABDatabaseManager.m
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

#import "ABDatabaseManager.h"

static ABDatabaseManager * sharedInstance = nil;

@implementation ABDatabaseManager

#pragma mark - Core Data stack

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize databaseOperationQueue = _databaseOperationQueue;

+ (ABDatabaseManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ABDatabaseManager new];
    });
    return sharedInstance;
}

- (NSString *)databaseStoreDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
}

- (NSOperationQueue *)databaseOperationQueue {
    if (!_databaseOperationQueue) {
        _databaseOperationQueue = [[NSOperationQueue alloc] init];
        _databaseOperationQueue.name = @"Database operation queue";
        _databaseOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _databaseOperationQueue;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:managedObjectModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[NSURL fileURLWithPath:[self databaseStoreDirectory]]
                       URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",persistentStoreName]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (_mainManagedObjectContext) {
        return _mainManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)childManagedObjectContext {
    NSManagedObjectContext *childManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [childManagedObjectContext setParentContext:self.mainManagedObjectContext];
    return childManagedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveMainContextWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)databaseUpdatedCompletionHandler {
    NSManagedObjectContext *context = self.mainManagedObjectContext;
    [context performBlock:^{
        NSError *error = nil;
        if ([context hasChanges]) {
            if ([context save:&error]) {
                if (databaseUpdatedCompletionHandler) {
                    databaseUpdatedCompletionHandler();
                }
            }
            else {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        else
        {
            if (databaseUpdatedCompletionHandler)
            {
                databaseUpdatedCompletionHandler();
            }
        }
    }];
}

- (void)saveChildContext:(NSManagedObjectContext *)childManagedObjectContext databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler {
    if (childManagedObjectContext) {
        [childManagedObjectContext performBlock:^{
            NSError *error;
            if ([childManagedObjectContext hasChanges] && ![childManagedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            } else {
                [self saveMainContextWithCompletionHandler:completionHandler];
            }
        }];
    }
}

- (void)saveChildContexts:(NSArray *)childManagedObjectContentexts databaseUpdatedCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler {
    static ABDatabaseUpdateSuccessfulCompletionHandler dbOperationsCompletionHandler = nil;
    if (completionHandler) {
        dbOperationsCompletionHandler = completionHandler;
    }
    if (childManagedObjectContentexts.count == 0) {
        [self saveMainContextWithCompletionHandler:dbOperationsCompletionHandler];
        return;
    }
    NSManagedObjectContext *childContext = [childManagedObjectContentexts lastObject];
    [childContext performBlock:^{
        NSError *error;
        if ([childContext hasChanges] && ![childContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        NSArray *subArray = [childManagedObjectContentexts subarrayWithRange:NSMakeRange(0, childManagedObjectContentexts.count - 1)];
        [self saveChildContexts:subArray databaseUpdatedCompletionHandler:nil];
    }];
}

@end
