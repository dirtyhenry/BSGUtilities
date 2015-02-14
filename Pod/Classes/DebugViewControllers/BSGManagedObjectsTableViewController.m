//
//  BSGManagedObjectsTableViewController.m
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/02/2015.
//
//

#import "BSGManagedObjectsTableViewController.h"
#import "BSGFetchedResultsControllerDataSource.h"


@interface BSGManagedObjectsTableViewController ()

@property (strong, nonatomic) BSGFetchedResultsControllerDataSource *dataSource;

@end

@implementation BSGManagedObjectsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

 // Configure the cell...

 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)setEntityDescription:(NSEntityDescription *)entityDescription {
    _entityDescription = entityDescription;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self.delegate mainAttributeKeyForEntityDescription:entityDescription] ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSLog(@"Main attribute key is: %@", sortDescriptor.key);
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    
    self.dataSource = [[BSGFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:frc cellIdentifier:@"BSGManagedObjectsViewControllerCell" configureCellBlock:^(id cell, id item) {
        NSManagedObject *object = item;
        UITableViewCell *myCell = cell;
        myCell.textLabel.text = [self.delegate stringForManagedObject:object];
    } tableView:self.tableView];

    self.tableView.dataSource = self.dataSource;
}

@end
