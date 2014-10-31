//
//  BSGViewController.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 10/30/2014.
//  Copyright (c) 2014 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGViewController.h"
#import <CoreData/CoreData.h>
#import "BSGEntitiesTableViewController.h"
#import "BSGWebViewController.h"


@interface BSGViewController ()

@end

@implementation BSGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Entities"]) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SampleModel" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        BSGEntitiesTableViewController *destinationVC = segue.destinationViewController;
        destinationVC.model = model;
    } else if ([segue.identifier isEqualToString:@"WebURL"]) {
        BSGWebViewController *destinationVC = segue.destinationViewController;
        destinationVC.urlString = @"http://bootstragram.com";
    } else if ([segue.identifier isEqualToString:@"WebMarkdown"]) {
        BSGWebViewController *destinationVC = segue.destinationViewController;
        NSError *error = nil;
        NSString *mdFilePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"md"];
        NSString *rawMarkdown = [NSString stringWithContentsOfFile:mdFilePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        destinationVC.rawMarkdownContent = rawMarkdown;
    }
}


@end
