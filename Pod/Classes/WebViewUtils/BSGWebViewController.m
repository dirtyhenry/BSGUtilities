//
//  BSGWebViewController.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 15/10/2014.
//  Copyright (c) 2014 Bootstragram. All rights reserved.
//

#import "BSGWebViewController.h"
#import <MMMarkdown/MMMarkdown.h>
#import "BSGWebViewDelegate.h"

@interface BSGWebViewController ()

@property (strong, nonatomic) BSGWebViewDelegate *webViewDelegate;

@end

@implementation BSGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the delegate
    self.webViewDelegate = [[BSGWebViewDelegate alloc] init];
    self.webViewDelegate.spinner = self.spinner;
    self.webView.delegate = self.webViewDelegate;

    [self.closeButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshContent];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshContent {
    // Load the content of the view
    if (self.rawMarkdownContent) {
        NSError *error = nil;
        NSURL *bundleBaseURL = [[NSBundle mainBundle] resourceURL];
        [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", [MMMarkdown HTMLStringWithMarkdown:self.rawMarkdownContent error:&error]] baseURL:bundleBaseURL];
        if (error) {
            NSLog(@"MMMarkdown Error: %@", error);
        }
    } else if (self.urlString) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    } else {
        NSLog(@"ERROR: at least urlString or rawMarkdownContent must be set");
    }
}

- (void)setRawMarkdownContent:(NSString *)rawMarkdownContent {
    _rawMarkdownContent = rawMarkdownContent;
    _urlString = nil;
    [self refreshContent];
}

- (void)setUrlString:(NSString *)urlString {
    _rawMarkdownContent = nil;
    _urlString = urlString;
    [self refreshContent];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //... do nothing...
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"Dictionary: %@", change);
        NSLog(@"Main thread? %@ %@", [NSThread isMainThread] ? @"yes" : @"no", self.webView.loading ? @"yes" : @"no");
        if (self.webView.loading) {
            [self.spinner startAnimating];
        } else {
            [self.spinner stopAnimating];
        }
    }
}

@end
