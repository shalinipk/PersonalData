//
//  PDDetailsViewController.m
//  PersonalData
//
//  Created by Shalini Kamala on 11/4/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDDetailsViewController.h"

@import WebKit;

@interface PDDetailsViewController () <WKUIDelegate>
@property UIActivityIndicatorView* spinner;
@property WKWebView* webView;

@end
@implementation PDDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    self.navigationItem.title = [self.pdItem title];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];
    

    // Do any additional setup after loading the view, typically from a nib.
    if(self.pdItem != nil) {

        self.spinner.center = self.view.center;
        
        [self.spinner startAnimating];
        
        NSString* urlString = [[self.pdItem link] stringByAppendingString:@"?displayMobileNavigation=0"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];

    }


}

#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
{

    // After succesfully navigation, hide activity indicator
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner stopAnimating];

    });

    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
{
    NSString *errorMessage = nil;
    if ((errorMessage = error.localizedFailureReason)) {
        NSLog(@"%@", error);
    }
    [self.spinner stopAnimating];
}
@end
