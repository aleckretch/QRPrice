//
//  EbayView.h
//  QRPrice
//
//  Created by Kyle Knez on 3/27/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EbayView : UIView <UIWebViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame url:(NSString*)url;
-(void)show;
-(void)dismiss;
-(void)relaodUrl:(NSString*)url;

@end
