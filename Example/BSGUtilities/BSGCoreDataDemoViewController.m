//
//  BSGCoreDataDemoViewController.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 25/08/2015.
//  Copyright (c) 2015 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGCoreDataDemoViewController.h"
@import BSGUtilities;

@interface BSGCoreDataDemoViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) BSGFetchedResultsControllerDataSource *dataSource;

@end

@implementation BSGCoreDataDemoViewController


- (NSArray *)fetchAll {
    // Fetch 'em all
    NSFetchRequest *allDemoObjects = [[NSFetchRequest alloc] init];
    [allDemoObjects setEntity:[NSEntityDescription entityForName:@"DemoCoreData" inManagedObjectContext:self.managedObjectContext]];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:allDemoObjects error:&error];
    return objects;
}


- (void)removeObject:(NSUInteger)numberOfObjects {
    NSArray *objects = [self fetchAll];

    if ([objects count] == 0) {
        NSLog(@"Empty");
        return;
    }

    NSUInteger maxIndex = 0;
    if (numberOfObjects == 0) {
        maxIndex = [objects count];
    } else {
        maxIndex = MIN(numberOfObjects, [objects count]);
    }

    //error handling goes here
    for (int i = 0; i < maxIndex; i++) {
        NSManagedObject *obj = [objects objectAtIndex:i];
        [self.managedObjectContext deleteObject:obj];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    //more error handling here
}


- (void)createObject:(NSUInteger)numberOfObjects {
    for (int i = 0; i < numberOfObjects; i++) {
        NSManagedObject *obj = [NSEntityDescription
                                insertNewObjectForEntityForName:@"DemoCoreData"
                                inManagedObjectContext:self.managedObjectContext];
        NSUInteger r = arc4random_uniform(5);
        [obj setValue:[NSString stringWithFormat:@"Section %lu", (unsigned long)r] forKey:@"mySection"];
        [obj setValue:[[NSUUID UUID] UUIDString] forKey:@"myAttribute"];
    }
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"CoreData Demo");

    [self removeObject:0];
    [self createObject:5];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DemoCoreData"];

    NSSortDescriptor *sortKey1 = [[NSSortDescriptor alloc] initWithKey:@"mySection" ascending:YES];
    NSSortDescriptor *sortKey2 = [[NSSortDescriptor alloc] initWithKey:@"myAttribute" ascending:YES];
    fetchRequest.sortDescriptors = @[ sortKey1, sortKey2 ];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"mySection"
                                                                                   cacheName:nil];

    self.dataSource = [[BSGFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:self.fetchedResultsController
                                                                                       cellIdentifier:@"CoreDataCell"
                                                                                   configureCellBlock:^(id cell, id item) {
                                                                                       UITableViewCell *myCell = (UITableViewCell *)cell;
                                                                                       NSManagedObject *myObject = (NSManagedObject *)item;
                                                                                       myCell.textLabel.text = [myObject valueForKey:@"myAttribute"];
                                                                                   } tableView:self.tableView];
    self.dataSource.reselectsAfterUpdates = YES;

    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addElementAction:(id)sender {
    [self createObject:1];
}

- (IBAction)updateElementAction:(id)sender {
    NSArray *objects = [self fetchAll];
    if ([objects count] == 0) {
        NSLog(@"Empty");
        return;
    }

    // Casting is safe here. Cf. http://stackoverflow.com/questions/19372312/objective-c-implicit-conversion-loses-integer-precision-nsuinteger
    uint32_t rnd = arc4random_uniform((uint32_t)[objects count]);

    NSManagedObject *object = [objects objectAtIndex:rnd];
    [self updateElement:object];
}


- (IBAction)removeElementAction:(id)sender {
    [self removeObject:1];
}


- (IBAction)updateSelectedElementAction:(id)sender {
    [self updateElement:[self.dataSource itemAtIndexPath:self.tableView.indexPathForSelectedRow]];
}


- (void)updateElement:(NSManagedObject *)object {
    NSLog(@"Concurrency Type: %lu", (unsigned long)self.managedObjectContext.concurrencyType);
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = self.managedObjectContext;
    [context performBlock:^{
        NSLog(@"Main thread: %@", ([NSThread isMainThread] ? @"yes" : @"no"));

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =
        [NSEntityDescription entityForName:@"DemoCoreData"
                    inManagedObjectContext:context];
        [request setEntity:entity];

        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"self == %@", object];
        [request setPredicate:predicate];

        NSError *error;
        NSArray *array = [context executeFetchRequest:request error:&error];
        if (array != nil) {
            NSUInteger count = [array count];
            if (count == 1) {
                NSManagedObject *tmp = [array objectAtIndex:0];
                [tmp setValue:@"Updated" forKey:@"myAttribute"];
                NSError *error = nil;
                NSLog(@"Updated object %@", object.objectID);
                [context save:&error];
            } else {
                NSLog(@"[ERROR] Count is %ld", [array count]);
            }
        } else {
            NSLog(@"[ERROR] Array is nil");
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select");

    [tableView beginUpdates];
    [tableView endUpdates];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will select");
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0;

    if ([indexPath isEqual:tableView.indexPathForSelectedRow]) {
        height = 66.0;
    }

    return height;
}


- (IBAction)reproduceCrash16:(id)sender {
    // 1. Find a section with at least 2 items
    NSInteger nbSections = self.fetchedResultsController.sections.count;

    NSInteger sectionToUse = -1;
    NSUInteger nbOfObjects = 0;
    for (NSInteger i = 0; i < nbSections; i++) {
        id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[i];
        if (section.numberOfObjects >= 2) {
            sectionToUse = i;
            nbOfObjects = section.numberOfObjects;
        }
    }

    if (sectionToUse == -1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Please create a section with at least 2 items"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   // Do nothing
                                               }]];

        [self presentViewController:alert animated:YES completion:^{
            // Do nothing
        }];
        return;
    }

    // 2. Deletes the second-to-last and updates the last one
    NSManagedObject *secondToLastObject = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:(nbOfObjects - 2) inSection:sectionToUse]];
    NSManagedObject *lastObject = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:(nbOfObjects - 1) inSection:sectionToUse]];

    [self.managedObjectContext deleteObject:secondToLastObject];
    [lastObject setValue:@"Crashed #16" forKey:@"myAttribute"];

    NSError *error = nil;
    [self.managedObjectContext save:&error];

}

@end
