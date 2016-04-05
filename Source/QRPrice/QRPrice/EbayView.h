//
//  EbayView.h
//  QRPrice
//
//  Created by Kyle Knez on 3/27/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EbayViewDelegate <NSObject>

- (void)ebayViewDidDismiss;

@end

@interface EbayView : UIView <UIWebViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame url:(NSString*)url;
-(void)show;
-(void)dismiss;
-(void)relaodUrl:(NSString*)url;

@property (nonatomic, retain) id<EbayViewDelegate> delegate;

@end
