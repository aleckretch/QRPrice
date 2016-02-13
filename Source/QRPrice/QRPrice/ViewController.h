//
//  ViewController.h
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "EBayAPIHandler.h"

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, EBayAPIHandlerDelegate>

@property (retain, nonatomic) IBOutlet AVCaptureSession *session;
@property (retain, nonatomic) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UILabel *lblDigits;
@property (retain, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (retain, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (retain, nonatomic) IBOutlet UIView *highlightView;
@property (retain, nonatomic) IBOutlet UIView *scannerView;

@property (assign, nonatomic) float price;

@end

