//
//  BSGEntitiesTableViewController.m
//  Pods
//
//  Created by Mickaël Floc'hlay on 30/10/2014.
//
//

#import "BSGEntitiesTableViewController.h"
#import "BSGManagedObjectsTableViewController.h"

#import "BSGArrayDataSource.h"
#import <CoreData/CoreData.h>


@interface BSGEntitiesTableViewController ()

@property (nonatomic, strong) BSGArrayDataSource *dataSource;

@end

@implementation BSGEntitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [NSException raise:@"Invalid data source"
                format:@"This class is designed to use an external data source"];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [NSException raise:@"Invalid data source"
                format:@"This class is designed to use an external data source"];
    return 0;
}


- (void)setModel:(NSManagedObjectModel *)model {
    _model = model;
    NSArray *entities = [model entities];

    self.dataSource = [[BSGArrayDataSource alloc] initWithItems:entities
                                                 cellIdentifier:@"BSGEntitiesViewControllerCell"
                                             configureCellBlock:^(id cell, id item) {
                                                 NSEntityDescription *entityDescription = item;
                                                 UITableViewCell *myCell = cell;
                                                 myCell.textLabel.text = entityDescription.name;
                                                 //TODO: display a count of the objects here
                                                 myCell.detailTextLabel.text = @"TODO";
    }];
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BSGManagedObjectsTableViewController"]) {
        NSEntityDescription *entityDescription = [self.dataSource itemAtIndexPath:[self.tableView indexPathForCell:sender]];
        BSGManagedObjectsTableViewController *vc = segue.destinationViewController;
        vc.delegate = self.delegate;
        vc.context = self.context;
        vc.entityDescription = entityDescription;
    }
}

@end
