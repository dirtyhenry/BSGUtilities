//
//  BSGWebViewDelegate.h
//  Petites Musiques de Train
//
//  Created by Mickaël Floc'hlay on 22/10/2014.
//  Copyright (c) 2014 Bootstragram. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This default delegate can be used for easy debugging on any `UIWebView`.
 */
@interface BSGWebViewDelegate : NSObject<UIWebViewDelegate>

/**
 *  A spinner being animated automatically when the web view is loading content.
 */
@property (nonatomic, weak) UIActivityIndicatorView *spinner;

@end
