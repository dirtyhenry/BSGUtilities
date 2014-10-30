//
//  BSGWebViewController.h
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 15/10/2014.
//  Copyright (c) 2014 Bootstragram. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 Embeddable web browser.
 
 Two options to load content:
 
 1. Set the `rawMarkdownContent` property with raw Markdown like `@"## Toto *Italic*`
 2. Set the `urlString` property with a URL string like `http://www.google.fr`

 TODO: eventually, this class should be moved in a private POD.
 TODO: what would be cool also would be to have a protocol delegate to load the content.
 */
@interface BSGWebViewController : UIViewController<UIWebViewDelegate>

@property (copy, nonatomic) NSString *rawMarkdownContent;
@property (copy, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)dismiss:(id)sender;

@end
