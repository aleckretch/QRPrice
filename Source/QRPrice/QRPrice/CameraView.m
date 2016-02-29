//
//  CameraView.m
//  QRPrice
//
//  Created by Kyle Knez on 2/15/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "CameraView.h"

@interface CameraView()

@property (retain, nonatomic) UIImageView *shutterView;
@property (retain, nonatomic) UIView *scannerView;
@property (retain, nonatomic) IBOutlet AVCaptureSession *session;
@property (retain, nonatomic) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;
@property (retain, nonatomic) UIButton *stopButton;

@property (assign) BOOL cameraActive;
@property (assign) CGRect startRect;
@property (assign) CGRect endRect;

@end

@implementation CameraView

-(instancetype)initWithFrame:(CGRect)frame superview:(UIView*)superview delegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [superview addSubview:self];
        
        self.cameraActive = false;
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *backLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size
                                                                        .height)];
        backLabel.text = @"Tap to start camera";
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.textColor = [UIColor whiteColor];
        [self addSubview:backLabel];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swap)];
        [self addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swap)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUp];
        
        self.startRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.endRect   = CGRectMake(CGRectGetMidX(frame), CGRectGetMidY(frame), 0, 0);
        
        self.scannerView = [[UIView alloc] initWithFrame: self.endRect];
        self.scannerView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scannerView];
        
        self.session = [[AVCaptureSession alloc] init];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *inputError = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
        
        if (inputError != nil )
        {
            // NO Camera
            return self;
        }
        
        [self.session addInput:input];
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
        [self.session addOutput:output];
        output.metadataObjectTypes = [output availableMetadataObjectTypes];
        
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.frame = self.scannerView.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.scannerView.layer addSublayer:self.previewLayer];
        
        self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        [self.stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside
         ];
        self.stopButton.layer.cornerRadius = self.stopButton.frame.size.height/2;
        self.stopButton.backgroundColor = [UIColor redColor];
        self.stopButton.hidden = true;
        [self addSubview:self.stopButton];
        
    }
    return self;
}

-(void)swap
{
    if (!self.cameraActive) {
        NSLog(@"Did swap\n");
        [self start];
        return;
    }
    [self stop];
}


-(void)start
{
    self.cameraActive = !self.cameraActive;
    
    self.scannerView.frame = self.startRect;
    self.previewLayer.frame = self.scannerView.bounds;
    self.stopButton.hidden = !self.stopButton.hidden;
    [self.session startRunning];
    
    [self.delegate cameraViewDidTurnOn:self];
    
}

-(void)stop
{
    
    self.cameraActive = !self.cameraActive;
    
    self.scannerView.frame = self.endRect;
    self.previewLayer.frame = self.scannerView.bounds;
    self.stopButton.hidden = !self.stopButton.hidden;
    [self.session stopRunning];

}

@end
