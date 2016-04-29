//
//  ABCoreDataBaseModelClass.h
//  DatabaseManagerSample
//
//  Created by Adithya Bhat on 28/04/15.
//  Copyright (c) 2015 Adithya Bhat. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ABDatabaseManager.h"

@interface ABCoreDataBaseModelClass : NSManagedObject

+ (NSString *)entityName;
+ (NSString *)identifierParameter;

+ (instancetype)newInstanceInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (instancetype)instanceWithId:(id)identifier
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                isNewlyCreated:(BOOL *)isNewlyCreated;
- (void)saveWithCompletionHandler:(ABDatabaseUpdateSuccessfulCompletionHandler)completionHandler;

@end
