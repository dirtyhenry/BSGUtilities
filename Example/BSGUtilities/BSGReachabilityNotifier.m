//
//  BSGReachabilityNotifier.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 17/02/2017.
//  Copyright © 2017 Mickaël Floc'hlay. All rights reserved.
//

#import "BSGReachabilityNotifier.h"
@import Reachability;

@interface BSGReachabilityNotifier()

@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGRect referenceFrame;

@property (strong, nonatomic) UIViewController *statusVC;
@property (strong, nonatomic) UIViewController *contentVC;

@property (strong, nonatomic) NSLayoutConstraint *reachabilityStatusBarHeightConstraint;

@end

@implementation BSGReachabilityNotifier

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
        [self setup];
    }
    return self;
}

- (CGFloat)statusBarHeight {
    return UIApplication.sharedApplication.statusBarFrame.size.height;
}

- (void)setup {
    // Allocate a reachability object
    self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];

    // Create a weak reference to self to prevent a retain cycle
    __weak typeof(self) weakSelf = self;

    // Set the blocks
    _reachability.reachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAlertViewController];
        });
    };

    _reachability.unreachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlertViewController];
        });
    };

    [self changeRootViewController];

    // Start the notifier, which will cause the reachability object to retain itself!
    [_reachability startNotifier];
}

- (void)changeRootViewController {
    UIViewController *oldRootController = _window.rootViewController;
    self.referenceFrame = oldRootController.view.frame;

    // Create the alert view controller
    UIViewController *alertViewController = [[UIViewController alloc] init];
    alertViewController.view.backgroundColor = [UIColor orangeColor];

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

    self.contentVC.view.layer.borderColor = [UIColor orangeColor].CGColor;
    self.contentVC.view.layer.borderWidth = 2.0;
    self.statusVC.view.layer.borderColor = [UIColor blueColor].CGColor;
    self.statusVC.view.layer.borderWidth = 2.0;

    // Resize views
    self.reachabilityStatusBarHeightConstraint = [_statusVC.view.heightAnchor constraintEqualToConstant:self.statusBarHeight];
    [NSLayoutConstraint activateConstraints:@[
                                              [_statusVC.view.leadingAnchor constraintEqualToAnchor:newRootController.view.leadingAnchor],
                                              [_statusVC.view.trailingAnchor constraintEqualToAnchor:newRootController.view.trailingAnchor],
                                              [_statusVC.view.topAnchor constraintEqualToAnchor:newRootController.view.topAnchor],
                                              _reachabilityStatusBarHeightConstraint
                                              ]];

    [NSLayoutConstraint activateConstraints:@[
                                              [_contentVC.view.leadingAnchor constraintEqualToAnchor:newRootController.view.leadingAnchor],
                                              [_contentVC.view.trailingAnchor constraintEqualToAnchor:newRootController.view.trailingAnchor],
                                              [_contentVC.view.topAnchor constraintEqualToAnchor:_statusVC.view.bottomAnchor],
                                              [_contentVC.view.bottomAnchor constraintEqualToAnchor:newRootController.bottomLayoutGuide.topAnchor]
                                              ]];
}

- (void)hideAlertViewController {
    NSLog(@"hide");
    _reachabilityStatusBarHeightConstraint.constant = self.statusBarHeight;
    [UIView animateWithDuration:0.300 animations:^{
        [_window.rootViewController.view layoutIfNeeded];
    }];
}

- (void)showAlertViewController {
    NSLog(@"show");
    _reachabilityStatusBarHeightConstraint.constant = 2.0 * self.statusBarHeight;
    [UIView animateWithDuration:0.300 animations:^{
        [_window.rootViewController.view layoutIfNeeded];
    }];
}

@end
