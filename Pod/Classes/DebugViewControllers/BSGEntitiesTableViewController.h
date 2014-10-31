//
//  BSGEntitiesTableViewController.h
//  Pods
//
//  Created by Mickaël Floc'hlay on 30/10/2014.
//
//

#import <UIKit/UIKit.h>

/**
 *  This table view controller is intended to be fed with a `NSManagedObjectModel`
 *  so that it displays the entities described in the model as its rows.
 *
 *  This table view controller is made for debug purpose only.
 */
@interface BSGEntitiesTableViewController : UITableViewController

/**
 *  The model for which entities should be listed. 
 */
@property (strong, nonatomic) NSManagedObjectModel *model;

@end
