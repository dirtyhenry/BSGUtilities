//
//  BSGViewController.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 10/30/2014.
//  Copyright (c) 2014 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGViewController.h"
#import <CoreData/CoreData.h>
#import "BSGWebViewController.h"
#import "BSGCoreDataDemoViewController.h"


@interface BSGViewController ()

@property (strong, nonatomic) NSDictionary *modelsAndMainAttributes;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation BSGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create lots of entities
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.modelsAndMainAttributes = @{ @"JohnLennon": @"humor", @"GeorgeHarrison": @"solo", @"PaulMcCartney": @"bass", @"RingoStarr": @"drums" };

    if ([[defaults stringForKey:@"FedCoreData-f2990926-9cbc-4bcf-a878-09d1b4072a8d"] isEqualToString:@"f2990926-9cbc-4bcf-a878-09d1b4072a8d"]) {
        // Do nothing. We can decide to do other stuff for later versions.
    } else {
        [defaults setObject:@"f2990926-9cbc-4bcf-a878-09d1b4072a8d" forKey:@"FedCoreData-f2990926-9cbc-4bcf-a878-09d1b4072a8d"];
        [defaults synchronize];

        for (NSString *entityName in [self.modelsAndMainAttributes allKeys]) {
            if (self.managedObjectContext)
                for (int i = 0; i < 10; i++) {
                    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
                    [object setValue:[NSString stringWithFormat:@"%@ %d", entityName, i] forKey:[self.modelsAndMainAttributes objectForKey:entityName]];
                }

            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Error while saving: %@", error);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Entities"]) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SampleModel" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        BSGEntitiesTableViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self;
        destinationVC.context = self.managedObjectContext;
        destinationVC.model = model;
    } else if ([segue.identifier isEqualToString:@"WebURL"]) {
        BSGWebViewController *destinationVC = segue.destinationViewController;
        destinationVC.urlString = @"https://bootstragram.com";
    } else if ([segue.identifier isEqualToString:@"WebText"]) {
        NSError *error = nil;
        NSString *mdFilePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"md"];
        NSString *rawMarkdown = [NSString stringWithContentsOfFile:mdFilePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        BSGWebViewController *destinationVC = segue.destinationViewController;
        destinationVC.rawText = rawMarkdown;
    } else if ([segue.identifier isEqualToString:@"CoreDataDemo"]) {
        BSGCoreDataDemoViewController *destinationVC = segue.destinationViewController;
        destinationVC.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SampleModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SampleModel"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - BSG Delegation

- (NSString *)mainAttributeKeyForEntityDescription:(NSEntityDescription *)entityDescription {
    return [self.modelsAndMainAttributes objectForKey:entityDescription.name];
}

- (NSString *)stringForManagedObject:(NSManagedObject *)managedObject {
    return [managedObject valueForKey:[self mainAttributeKeyForEntityDescription:managedObject.entity]];
}

@end
