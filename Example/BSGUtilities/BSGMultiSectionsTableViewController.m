//
//  BSGMultiSectionsTableViewController.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 26/05/2016.
//  Copyright © 2016 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGMultiSectionsTableViewController.h"
#import "BSGMultiSectionsArrayDataSource.h"


@interface BSGMultiSectionsTableViewController ()

@property(nonatomic, strong) BSGMultiSectionsArrayDataSource *dataSource;

@end

@implementation BSGMultiSectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *dataArray = @[ @{ @"sectionTitle": @"Group A", @"objects": @[ @{ @"title": @"France" }, @{ @"title": @"Angleterre" }, @{ @"title": @"Italie" }]}, @{ @"sectionTitle": @"Group B", @"objects": @[ @{ @"title": @"Espagne" }]}];

    self.dataSource = [[BSGMultiSectionsArrayDataSource alloc] initWithItems:dataArray cellIdentifier:@"BSGMultiSectionsTableViewControllerCell"
                                                          configureCellBlock:^(id cell, id item) {
                                                              UITableViewCell *myCell = (id)cell;
                                                              myCell.textLabel.text = [item objectForKey:@"title"];
    }];

    self.tableView.dataSource = _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
