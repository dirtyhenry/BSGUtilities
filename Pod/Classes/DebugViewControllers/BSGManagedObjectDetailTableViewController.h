//
//  BSGManagedObjectDetailTableViewController.h
//  Pods
//
//  Created by Mickaël Floc'hlay on 24/02/2015.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BSGEntitiesTableViewController.h"


@interface BSGManagedObjectDetailTableViewController : UITableViewController

/**
 *  The delegate object that is used to describe objects.
 *  cf. `BSGEntitiesTableViewDelegate` for implementation details.
 */
@property (weak, nonatomic) id<BSGEntitiesTableViewDelegate> delegate;

@property (strong, nonatomic) NSManagedObject *managedObject;

@end
