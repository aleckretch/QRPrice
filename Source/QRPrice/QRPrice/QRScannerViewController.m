//
//  QRScannerViewController.m
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "QRScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScannerViewController  () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *previewLayer;
    UIView *higlightView;
    UILabel *label;
}
@end

@implementation QRScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"(none)";
    [self.view addSubview:label];
    
    higlightView = [[UIView alloc] init];
    higlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;;
    higlightView.layer.borderColor = [[UIColor greenColor] CGColor];
    higlightView.layer.borderWidth = 3;
    [self.view addSubview: higlightView];
    
    session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    
    if (inputError != nil) {
        NSLog(@"You can't use a simulator because it doesn't have a camera");
        return;
    }
    
    [session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue: dispatch_get_main_queue()];
    [session addOutput:output];
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    [session startRunning];
    
    [self.view bringSubviewToFront:higlightView];
    [self.view bringSubviewToFront:label];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataObject *barCodeObject;
    NSString *detectionString;
    
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                             AVMetadataObjectTypeCode39Code,
                             AVMetadataObjectTypeCode39Mod43Code,
                             AVMetadataObjectTypeEAN13Code,
                             AVMetadataObjectTypeEAN8Code,
                             AVMetadataObjectTypeCode93Code,
                             AVMetadataObjectTypeCode128Code,
                             AVMetadataObjectTypePDF417Code,
                             AVMetadataObjectTypeQRCode,
       						 AVMetadataObjectTypeAztecCode ];
    
    for(AVMetadataObject* metadata in metadataObjects) {
        for(NSString* objectString in barCodeTypes) {
            if ([objectString isEqualToString: metadata.type]) {
                barCodeObject = [ previewLayer transformedMetadataObjectForMetadataObject:metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                // TODO: UNComment this if you want it to stop when it finds a bar code.
                // [session stopRunning];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            label.text = detectionString;
            break;
        } else {
            label.text = @"(none)";
        }
    }
    
    higlightView.frame = highlightViewRect;
    
}


@end







