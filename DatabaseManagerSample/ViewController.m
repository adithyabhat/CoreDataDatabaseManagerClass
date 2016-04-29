//
//  ViewController.m
//  DatabaseManagerSample
//
//  Created by Bhat, Adithya H (external - Project) on 4/4/16.
//  Copyright © 2016 Adithya Bhat, Bangalore. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testDB];
}

- (void)testDB {
    //Creating a person instance in mainManagedObjectContext and save
    BOOL personNewlyCreated = false;
    Person *person1 = [Person instanceWithId:@"AB"
                      inManagedObjectContext:[[ABDatabaseManager sharedInstance] mainManagedObjectContext]
                              isNewlyCreated:&personNewlyCreated];
    if (personNewlyCreated) {
        person1.name = @"AB";
        person1.age = @23;
        person1.address = @"Mangalore";
        [person1 saveWithCompletionHandler:^{
            NSLog(@"Person1 saved successfully");
        }];
    }
    
    //Creating a person insance in childManagedObjectContext and save
    personNewlyCreated = false;
    Person *person2 = [Person instanceWithId:@"BC"
                      inManagedObjectContext:[[ABDatabaseManager sharedInstance] childManagedObjectContext]
                              isNewlyCreated:&personNewlyCreated];
    if (personNewlyCreated) {
        person2.name = @"BC";
        person2.age = @24;
        person2.address = @"Bangalore";
        [person2 saveWithCompletionHandler:^{
            NSLog(@"Person2 saved successfully");
        }];
    }
    
    //Saving multiple child contexts
    personNewlyCreated = false;
    NSMutableArray *managedObjectContexts = [@[] mutableCopy];
    NSManagedObjectContext *childContext = [[ABDatabaseManager sharedInstance] childManagedObjectContext];
    managedObjectContexts[0] = childContext;
    Person *person3 = [Person instanceWithId:@"CD"
                      inManagedObjectContext:childContext
                              isNewlyCreated:&personNewlyCreated];
    childContext = [[ABDatabaseManager sharedInstance] childManagedObjectContext];
    managedObjectContexts[1] = childContext;
    Person *person4 = [Person instanceWithId:@"DE"
                      inManagedObjectContext:childContext
                              isNewlyCreated:&personNewlyCreated];
    person3.age = person4.age = @25;
    person3.address = person4.address = @"Tumkur";
    [[ABDatabaseManager sharedInstance] saveChildContexts:managedObjectContexts
                         databaseUpdatedCompletionHandler:^{
                             NSLog(@"Saved both child contexts");
                         }];
}

@end
