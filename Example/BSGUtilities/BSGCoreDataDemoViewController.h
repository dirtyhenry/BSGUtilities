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

@end
