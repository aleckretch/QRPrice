//
//  CameraView.h
//  QRPrice
//
//  Created by Kyle Knez on 2/15/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraView : UIView

-(instancetype)initWithFrame:(CGRect)frame superview:(UIView*)superview delegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate;
-(void)stop;
-(void)start;

@end
