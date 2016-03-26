//
//  ViewController.m
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "ViewController.h"

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
    self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.cam.frame.origin.y+self.cam.frame.size.height+10, 100, 100)];
    [self.view addSubview:self.productImageView];
    [self.productImageView setHidden:YES];
    
    //product title label
    self.lblProductTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10, self.productImageView.frame.origin.y, self.view.frame.size.width-(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10)-(10), self.productImageView.frame.size.height)];
    self.lblProductTitle.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    self.lblProductTitle.textColor = [UIColor darkGrayColor];
    self.lblProductTitle.numberOfLines = 4;
    [self.view addSubview:self.lblProductTitle];
    [self.lblProductTitle setHidden:YES];
    
    //product price label
    self.lblProductPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.productImageView.frame.origin.y+self.productImageView.frame.size.height+10, self.view.frame.size.width-(10*2), 20)];
    self.lblProductPrice.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.lblProductPrice.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.lblProductPrice];
    [self.lblProductPrice setHidden:YES];
    
    //ebay button
    self.btnEbay = [self getButtonWithColor:COLOR_GREEN title:@"Post to eBay" frame:CGRectMake(10, self.lblProductPrice.frame.origin.y+self.lblProductPrice.frame.size.height+10, self.view.frame.size.width-20, 40)];
    [self.btnEbay addTarget:self action:@selector(onTapButtonEbay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnEbay];
    [self.btnEbay setHidden:YES];
    
    self.btnRestart = [self getButtonWithColor:COLOR_RED title:@"Restart" frame:CGRectMake(10, self.btnEbay.frame.origin.y+self.btnEbay.frame.size.height+10, self.view.frame.size.width-20, 40)];
    [self.btnRestart addTarget:self action:@selector(onTapButtonRestart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnRestart];
    [self.btnRestart setHidden:YES];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor darkGrayColor];
    self.activityIndicator.frame = CGRectMake(0, self.cam.frame.origin.y+self.cam.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.cam.frame.origin.y+self.cam.frame.size.height));
    [self.view addSubview:self.activityIndicator];

}

- (void)setScannerOnWithFrame:(CGRect)frame {
    self.cam = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) superview:self.view delegate:self];
    self.cam.delegate = self;
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cam.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.cam.frame.size.height)];
    [self.view addSubview:self.mainView];
    self.mainView.backgroundColor = [UIColor whiteColor];

}

//this method connects all elements associated with item info
- (void)setItemInfoHidden:(BOOL)hidden {
    if (hidden)
    {
        [self.lblProductPrice setHidden:YES];
        [self.lblProductTitle setHidden:YES];
        [self.productImageView setHidden:YES];
        self.lblProductPrice.text = @"";
        self.lblProductTitle.text = @"";
        self.currentCategoryId = @"";
        self.productImageView.image = nil;
        [self.btnEbay setHidden:YES];
        [self.btnRestart setHidden:YES];
    }
    else
    {
        if (self.lblProductPrice.text && self.lblProductTitle.text && self.productImageView.image && self.currentCategoryId)
        {
            [self.lblProductPrice setHidden:NO];
            [self.lblProductTitle setHidden:NO];
            [self.productImageView setHidden:NO];
            [self.btnEbay setHidden:NO];
            [self.btnRestart setHidden:NO];
        }
        [self.activityIndicator stopAnimating];
    }
    
}

- (void)onTapButtonEbay {
    NSString *urlString = [NSString stringWithFormat:@"http://csr.ebay.com/sell/list.jsf?usecase=create&mode=AddItem&categoryId=%@&rp=srp&title=%@", self.currentCategoryId, self.lblProductTitle.text];
    NSString *urlStringHtml = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStringHtml];
    
    //NOTE FOR KYLE: REPLACE THIS BELOW CODE WITH THE CALL TO OPEN THE WEBVIEW CONTROLLER
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

- (void)onTapButtonRestart {
    self.checkingPriceIsDisabled = NO;
    [self setItemInfoHidden:YES];
    
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
        
        if (detectionString != nil && !self.checkingPriceIsDisabled)
        {
            self.checkingPriceIsDisabled = YES;
            [self.activityIndicator startAnimating];
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

- (void)cameraViewDidTurnOn:(CameraView *)controller {
    self.checkingPriceIsDisabled = NO;
    
}

- (void)getEbayProductTitle:(NSString *)title {
    self.lblProductTitle.text = title;
    [self setItemInfoHidden:NO];
    
}

- (void)getEbayProductImageURL:(NSString *)url {
    NSURL *imageURL = [NSURL URLWithString:url];
    UIImage *imgProduct = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    self.productImageView.image = imgProduct;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setItemInfoHidden:NO];
    
}

- (UIButton *)getButtonWithColor:(UIColor *)color title:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.clipsToBounds = YES;
    btn.exclusiveTouch = YES;
    btn.frame = frame;
    btn.layer.cornerRadius = 4.0;
    [btn setBackgroundImage:[self getImageWithColor:color frame:CGRectMake(0, 0, frame.size.width, frame.size.height)] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16]];
    
    return btn;
    
}

- (UIImage *)getImageWithColor:(UIColor *)color frame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)getEbayProductPrice:(float)price {
    self.price = price;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *priceWithCommas = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    self.lblProductPrice.text = [NSString stringWithFormat:@"Cheapest price on eBay: $%@ USD", priceWithCommas];
    [self setItemInfoHidden:NO];
    
}

- (void)getEbayCategoryId:(NSString *)categoryId {
    self.currentCategoryId = categoryId;
    [self setItemInfoHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
