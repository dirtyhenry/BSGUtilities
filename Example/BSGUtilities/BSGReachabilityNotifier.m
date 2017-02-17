//
//  BSGReachabilityNotifier.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 17/02/2017.
//  Copyright © 2017 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGReachabilityNotifier.h"
@import Reachability;
@import RMessage;

@interface BSGReachabilityNotifier()

@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGFloat reachabilityStatusBarHeight;
@property (nonatomic) CGRect referenceFrame;

@property (strong, nonatomic) UIViewController *statusVC;
@property (strong, nonatomic) UIViewController *contentVC;

@end

@implementation BSGReachabilityNotifier

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
        self.reachabilityStatusBarHeight = 40.0;
        [self setup];
    }
    return self;
}

- (void)setup {
    // Allocate a reachability object
    self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];

    // Set the blocks
    _reachability.reachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertViewController];
        });
    };

    _reachability.unreachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAlertViewController];
        });
    };

    // Start the notifier, which will cause the reachability object to retain itself!
    [_reachability startNotifier];

    [self changeRootViewController];
}

- (void)changeRootViewController {
    UIViewController *oldRootController = _window.rootViewController;
    self.referenceFrame = oldRootController.view.frame;

    // Create the alert view controller
    UIViewController *alertViewController = [[UIViewController alloc] init];
    UIView *myAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _referenceFrame.size.width, _reachabilityStatusBarHeight)];
    myAlertView.backgroundColor = [UIColor orangeColor];
    [alertViewController.view addSubview:myAlertView];

    // Change the root view controller
    UIViewController *newRootController = [[UIViewController alloc] init];

    [newRootController addChildViewController:alertViewController];
    [newRootController.view addSubview:alertViewController.view];
    alertViewController.view.translatesAutoresizingMaskIntoConstraints = false;
    [alertViewController didMoveToParentViewController:newRootController];

    [newRootController addChildViewController:oldRootController];
    [newRootController.view addSubview:oldRootController.view];
    oldRootController.view.translatesAutoresizingMaskIntoConstraints = false;
    [oldRootController didMoveToParentViewController:newRootController];

    _window.rootViewController = newRootController;

    // Store references
    self.contentVC = oldRootController;
    self.statusVC = alertViewController;

    // Resize views
    alertViewController.view.frame = CGRectMake(0, 0, _referenceFrame.size.width, _reachabilityStatusBarHeight);
    oldRootController.view.frame = CGRectMake(0, _reachabilityStatusBarHeight, _referenceFrame.size.width, _referenceFrame.size.height - _reachabilityStatusBarHeight);
}

- (void)hideAlertViewController {
    NSLog(@"hide");
    [UIView animateWithDuration:0.300 animations:^{
        self.statusVC.view.frame = CGRectMake(0, 0, _referenceFrame.size.width, 20.0);
        self.contentVC.view.frame = CGRectMake(0, 20.0, _referenceFrame.size.width, _referenceFrame.size.height - 20.0);
    }];
}

- (void)showAlertViewController {
    NSLog(@"show");
    [UIView animateWithDuration:0.300 animations:^{
        self.statusVC.view.frame = CGRectMake(0, 0, _referenceFrame.size.width, _reachabilityStatusBarHeight);
        self.contentVC.view.frame = CGRectMake(0, _reachabilityStatusBarHeight, _referenceFrame.size.width, _referenceFrame.size.height - _reachabilityStatusBarHeight);
    }];
}

@end
