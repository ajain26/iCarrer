//
//  WebViewVC.m
//  iCareer
//
//  Created by Hitesh on 12/5/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.delegate = self;
}
#pragma mark - webview
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = false;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
