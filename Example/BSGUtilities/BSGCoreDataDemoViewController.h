//
//  BSGCoreDataDemoViewController.h
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 25/08/2015.
//  Copyright (c) 2015 Mickaël Floc'hlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSGCoreDataDemoViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addElementAction:(id)sender;
- (IBAction)updateElementAction:(id)sender;
- (IBAction)updateSelectedElementAction:(id)sender;
- (IBAction)removeElementAction:(id)sender;


/**
 IBAction that reproduces the scenario described here: http://stackoverflow.com/questions/12438827/how-to-use-newindexpath-for-nsfetchedresultschangeupdate
 as a possible source of crash #16.
 
 In other words, it:
 
 1. deletes the second-to-last-item of a section
 1. it updates the last item of that section

 @param sender the sender of the action
 */
- (IBAction)reproduceCrash16:(id)sender;

@end
