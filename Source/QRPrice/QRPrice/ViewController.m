//
//  ViewController.m
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "ViewController.h"
#import "CameraView.h"

@interface ViewController ()

@property (retain, nonatomic) UIView* cameraView;
@property (retain, nonatomic) CameraView *cam;
@property (retain, nonatomic) UIView* mainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayout];
    // Do any additional setup after loading the view, typically from a nib.
}

/*
 
 TODO:
 
 Highest priority:
 
 - Start camera in off state initially. Have button in place to turn camera on.
 - Issue: Some obscure items do not show up in eBay's catalogue database. When this is the case need to get image and title from the listing directly.
 - Include failure UI elements if there are no listings for giving ISBN number.
 - Include start text or objects in body with text along the lines of "Awaiting first scan..."
 - Include Activity Indicator during the time a bar code is scanned until the time.
 - Include way to toggle camera on and off (i.e. the button when it is off, and an 'x' button when it is on).
 - Hide product image, title, and price when scanning another object.
 - Improve UI elements, specifically for this version improving label fonts.
 - Remove camera overlay (the ISBN label... meaningless to user).
 - Add ability to post for sale on eBay.
 
 Lower priority:
 
 - Allow users to track their earnings through the app.
 - Allow users to post the product to other marketplaces.
 - Add LaunchScreen.
 - Add app icon.
 
*/

- (void)setLayout {
    [self setScannerOnWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, 200)];
    
    //product image
    self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.scannerView.frame.origin.y+self.scannerView.frame.size.height+10, 100, 100)];
    [self.view addSubview:self.productImageView];
    [self.productImageView setHidden:YES];
    
    //product title label
    self.lblProductTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10, self.productImageView.frame.origin.y, self.view.frame.size.width-(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10)-(10), self.productImageView.frame.size.height)];
    self.lblProductTitle.font = [UIFont systemFontOfSize:18]; //TODO custom font
    self.lblProductTitle.textColor = [UIColor darkGrayColor];
    self.lblProductTitle.numberOfLines = 4;
    [self.view addSubview:self.lblProductTitle];
    [self.lblProductTitle setHidden:YES];
    
    //product price label
    self.lblProductPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.productImageView.frame.origin.y+self.productImageView.frame.size.height+10, self.view.frame.size.width-(10*2), 20)];
    self.lblProductPrice.font = [UIFont systemFontOfSize:18]; //TODO custom font
    self.lblProductPrice.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.lblProductPrice];
    [self.lblProductPrice setHidden:YES];

}

- (void)setScannerOnWithFrame:(CGRect)frame {
    
    self.cam = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) superview:self.view delegate:self];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cam.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.cam.frame.size.height)];
    [self.view addSubview:self.mainView];
    self.mainView.backgroundColor = [UIColor whiteColor];
    
    /*
    
    self.scannerView = [[UIView alloc] initWithFrame:frame];
    
    self.lblDigits = [[UILabel alloc] init];
    self.lblDigits.frame = CGRectMake(0, self.scannerView.bounds.size.height - 40, self.scannerView.bounds.size.width, 40);
    self.lblDigits.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.lblDigits.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    self.lblDigits.textColor = [UIColor whiteColor];
    self.lblDigits.textAlignment = NSTextAlignmentCenter;
    self.lblDigits.text = @"(none)";
    [self.scannerView addSubview:self.lblDigits];
    
    self.highlightView = [[UIView alloc] init];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.highlightView.layer.borderColor = [[UIColor greenColor] CGColor];
    self.highlightView.layer.borderWidth = 3;
    [self.scannerView addSubview: self.highlightView];
    
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    
    if (inputError != nil) {
        //No camera
        return;
    }
    
    [self.session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue: dispatch_get_main_queue()];
    [self.session addOutput:output];
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = self.scannerView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.scannerView.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    
    [self.scannerView bringSubviewToFront:self.highlightView];
    [self.scannerView bringSubviewToFront:self.lblDigits];
    
    [self.view addSubview:self.scannerView];
    
    /*
    UIImage* shutterImage = [[UIImage alloc] initWithContentsOfFile:@"ShutterImageOne"];
   	self.shutterView = [[UIImageView alloc] initWithImage:shutterImage];
    self.shutterView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/4);
    [self.view addSubview:self.shutterView];
    */
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
                barCodeObject = [self.previewLayer transformedMetadataObjectForMetadataObject:metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                // TODO: UNComment this if you want it to stop when it finds a bar code.
                // [session stopRunning];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            self.lblDigits.text = detectionString;
            EBayAPIHandler *eBayAPIHandlerGeneric = [[EBayAPIHandler alloc] init];
            [eBayAPIHandlerGeneric getGenericInformationForISBN:detectionString];
            eBayAPIHandlerGeneric.delegate = self;
            EBayAPIHandler *eBayAPIHandlerPricing = [[EBayAPIHandler alloc] init];
            [eBayAPIHandlerPricing getPricingInformationForISBN:detectionString];
            eBayAPIHandlerPricing.delegate = self;
            break;
        }
        else
        {
            self.lblDigits.text = @"(none)";
        }
    }
    
    self.highlightView.frame = highlightViewRect;
    
}

- (void)getEbayProductTitle:(NSString *)title {
    [self.lblProductTitle setHidden:NO];
    self.lblProductTitle.text = title;
    
}

- (void)getEbayProductImageURL:(NSString *)url {
    [self.productImageView setHidden:NO];
    NSURL *imageURL = [NSURL URLWithString:url];
    UIImage *imgProduct = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    self.productImageView.image = imgProduct;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)getEbayProductPrice:(float)price {
    self.price = price;
    [self.lblProductPrice setHidden:NO];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *priceWithCommas = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    self.lblProductPrice.text = [NSString stringWithFormat:@"Cheapest price on eBay: $%@ USD", priceWithCommas];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
