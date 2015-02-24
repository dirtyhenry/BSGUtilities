//
//  BSGFetchedResultsControllerDataSource.m
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/02/2015.
//
//

#import "BSGFetchedResultsControllerDataSource.h"

@interface BSGFetchedResultsControllerDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) BSGTableViewCellConfigureBlock configureCellBlock;
@property (weak, nonatomic) UITableView *tableView;

@end


@implementation BSGFetchedResultsControllerDataSource

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                        cellIdentifier:(NSString *)aCellIdentifier
                    configureCellBlock:(BSGTableViewCellConfigureBlock)aConfigureCellBlock
tableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.fetchedResultsController = fetchedResultsController;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
        self.tableView = tableView;

        // Perform the fetch!
        self.fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"An error happened while performing performFetch.");
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}


- (void)controller:(NSFetchedResultsController*)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath*)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath*)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

@end
