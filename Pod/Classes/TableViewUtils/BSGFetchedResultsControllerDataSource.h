//
//  BSGFetchedResultsControllerDataSource.h
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/02/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BSGCommonDataSource.h"


/**
 A `UITableViewDataSource` implementation using an `NSFetchedResultsController` as a base.
 */
@interface BSGFetchedResultsControllerDataSource : NSObject<UITableViewDataSource>

/**
 *  Initializer.
 *
 *  @param fetchedResultsController the `NSFetchedResultsController` instance to use
 *  @param aCellIdentifier          the cell identifier
 *  @param aConfigureCellBlock      the block to configure cells
 *  @param tableView                the table view being sourced
 *
 *  @return <#return value description#>
 */
- (id)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                        cellIdentifier:(NSString *)aCellIdentifier
                    configureCellBlock:(BSGTableViewCellConfigureBlock)aConfigureCellBlock
                             tableView:(UITableView *)tableView;

@end
