//
//  ABCoreDataBaseModelClass.m
//  DatabaseManagerSample
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

#import "ABCoreDataBaseModelClass.h"

@implementation ABCoreDataBaseModelClass

+ (NSString *)entityName {
    //Subclasses can override this
    return NSStringFromClass([self class]);
}

+ (NSString *)identifierParameter {
    //Subclasses should override as required
    return @"";
}

+ (instancetype)newInstanceInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:managedObjectContext];
}

+ (instancetype)instanceWithId:(id)identifier
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                isNewlyCreated:(BOOL *)isNewlyCreated {
    id instance;
    *isNewlyCreated = false;
    if (managedObjectContext) {
        NSError *error;
        if (identifier){
            //Check if object instance already exists
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            NSString *predicateFormat = [[self identifierParameter] stringByAppendingString:@"==%@"];
            request.predicate = [NSPredicate predicateWithFormat:predicateFormat, identifier];
            
            NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
            instance = [results firstObject];
        }
        // Create if its nil.
        if (instance == nil) {
            instance = [self newInstanceInManagedObjectContext:managedObjectContext];
            [instance setValue:identifier forKey:[self identifierParameter]];
            *isNewlyCreated = true;
        }
    }
    return instance;
}

- (void)saveWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler {
    ABDatabaseManager *dbManager = [ABDatabaseManager sharedInstance];
    if ([self.managedObjectContext isEqual:[dbManager mainManagedObjectContext]]) {
        [dbManager saveMainContextWithCompletionHandler:completionHandler];
    }
    else {
        [dbManager saveChildContext:self.managedObjectContext databaseUpdatedCompletionHandler:completionHandler];
    }
}

@end
