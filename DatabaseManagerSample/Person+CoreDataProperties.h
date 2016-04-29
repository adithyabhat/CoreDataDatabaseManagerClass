//
//  Person+CoreDataProperties.h
//  DatabaseManagerSample
//
//  Created by Bhat, Adithya H (external - Project) on 4/29/16.
//  Copyright © 2016 Adithya Bhat, Bangalore. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
