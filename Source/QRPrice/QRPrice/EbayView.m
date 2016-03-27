//
//  EbayView.m
//  QRPrice
//
//  Created by Kyle Knez on 3/27/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "EbayView.h"

@interface EbayView()

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton*  button;
@property (nonatomic, strong) UIActivityIndicatorView* activityView;

@property CGPoint showPoint;
@property CGPoint hidePoint;

@end

@implementation EbayView

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Set points
        self.showPoint = CGPointMake(frame.origin.x, frame.origin.y);
        self.hidePoint = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height);
    
    	// Close button
    	_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 25)];
    	[_button setTitle:@"Done" forState:UIControlStateNormal];
    	[_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    	[_button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    	[self addSubview:_button];
    
    	// Web View
    	_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 25, frame.size.width, frame.size.height - 25)];
    	_webView.delegate = self;
    	[self addSubview:_webView];
    	NSURL* mainURL = [[NSURL alloc] initWithString:url];
    	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:mainURL];
    	[_webView loadRequest:request];
        _webView.hidden = true;
        
        // Activity View
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:_webView.frame];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activityView];
        [_activityView startAnimating];
        
    }
    
    return self;
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Did start loading\n");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityView stopAnimating];
    _webView.hidden = false;
}

-(void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(_hidePoint.x, _hidePoint.y, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(_showPoint.x, _showPoint.y, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)relaodUrl:(NSString*)url
{
    NSURL* mainURL = [[NSURL alloc] initWithString:url];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:mainURL];
    [_webView loadRequest:request];
}

@end
