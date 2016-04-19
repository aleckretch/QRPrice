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
@property (retain, nonatomic) EbayView* ebayView;
@property (retain, nonatomic) BackView* backView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLayout];
    
}

- (void)setLayout {
    [self setScannerOnWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, 200)];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cam.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.cam.frame.size.height)];
    [self.view addSubview:self.contentView];
    
    //product image
    self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, 10, 100, 100)];
    [self.contentView addSubview:self.productImageView];
    [self.productImageView setHidden:YES];
    
    //product title label
    self.lblProductTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10, self.productImageView.frame.origin.y, self.view.frame.size.width-(self.productImageView.frame.origin.x+self.productImageView.frame.size.width+10)-(10), self.productImageView.frame.size.height)];
    self.lblProductTitle.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    self.lblProductTitle.textColor = [UIColor darkGrayColor];
    self.lblProductTitle.numberOfLines = 4;
    [self.contentView addSubview:self.lblProductTitle];
    [self.lblProductTitle setHidden:YES];
    
    //product price label
    self.lblProductPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.productImageView.frame.origin.y+self.productImageView.frame.size.height+10, self.view.frame.size.width-(10*2), 20)];
    self.lblProductPrice.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.lblProductPrice.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.lblProductPrice];
    [self.lblProductPrice setHidden:YES];
    
    //entries label
    self.lblEntries = [[UILabel alloc] initWithFrame:CGRectMake(10, self.lblProductPrice.frame.origin.y+self.lblProductPrice.frame.size.height+10, self.view.frame.size.width-(10*2), 20)];
    self.lblEntries.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.lblEntries.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.lblEntries];
    [self.lblEntries setHidden:YES];
    
    //recommended price label
    self.lblRecommendedPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.lblEntries.frame.origin.y+self.lblEntries.frame.size.height+10, self.view.frame.size.width-(10*2), 20)];
    self.lblRecommendedPrice.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.lblRecommendedPrice.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.lblRecommendedPrice];
    [self.lblRecommendedPrice setHidden:YES];
    
    //ebay button
    self.btnEbay = [self getButtonWithColor:COLOR_GREEN title:@"Post to eBay" frame:CGRectMake(10, self.lblRecommendedPrice.frame.origin.y+self.lblRecommendedPrice.frame.size.height+10, self.view.frame.size.width-20, 40)];
    [self.btnEbay addTarget:self action:@selector(onTapButtonEbay) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnEbay];
    [self.btnEbay setHidden:YES];
    
    self.btnRestart = [self getButtonWithColor:COLOR_RED title:@"Restart" frame:CGRectMake(10, self.btnEbay.frame.origin.y+self.btnEbay.frame.size.height+10, self.view.frame.size.width-20, 40)];
    [self.btnRestart addTarget:self action:@selector(onTapButtonRestart) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnRestart];
    [self.btnRestart setHidden:YES];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor darkGrayColor];
    self.activityIndicator.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.contentView addSubview:self.activityIndicator];
    
    //buttons
    self.btnHistory = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHistory.exclusiveTouch = YES;
    UIImage *imgHistory = [UIImage imageNamed:@"btn_history.png"];
    [self.btnHistory setImage:imgHistory forState:UIControlStateNormal];
    [self.btnHistory addTarget:self action:@selector(onTapButtonHistory) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnHeight = imgHistory.size.height/2;
    self.btnHistory.frame = CGRectMake(10, self.view.frame.size.height-btnHeight-10, btnHeight, btnHeight);
    [self.btnHistory setTintColor:COLOR_LIGHT_BLUE];
    [self.view addSubview:self.btnHistory];
    
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnCancel.exclusiveTouch = YES;
    UIImage *imgCancel = [UIImage imageNamed:@"btn_cancel.png"];
    [self.btnCancel setImage:imgCancel forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(onTapButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel.frame = CGRectMake(10, self.view.frame.size.height-btnHeight-10, btnHeight, btnHeight);
    [self.btnCancel setTintColor:COLOR_LIGHT_BLUE];
    [self.view addSubview:self.btnCancel];
    [self.btnCancel setHidden:YES];
    
    self.btnClearHistory = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnClearHistory.exclusiveTouch = YES;
    [self.btnClearHistory addTarget:self action:@selector(onTapButtonClearHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClearHistory setTitle:@"Clear history" forState:UIControlStateNormal];
    [self.btnClearHistory.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14]];
    [self.btnClearHistory setTintColor:COLOR_LIGHT_BLUE];
    [self.btnClearHistory sizeToFit];
    self.btnClearHistory.frame = CGRectMake(self.view.frame.size.width-self.btnClearHistory.frame.size.width-10, self.view.frame.size.height-self.btnClearHistory.frame.size.height-10, self.btnClearHistory.frame.size.width, self.btnCancel.frame.size.height);
    [self.view addSubview:self.btnClearHistory];
    [self.btnClearHistory setHidden:YES];
    
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
        [self.lblEntries setHidden:YES];
        [self.lblRecommendedPrice setHidden:YES];
        self.lblProductPrice.text = @"";
        self.lblProductTitle.text = @"";
        self.currentCategoryId = @"";
        self.lblProductPrice.text = @"";
        self.productImageView.image = nil;
        [self.btnEbay setHidden:YES];
        [self.btnRestart setHidden:YES];
        self.historySaved = NO;
    }
    else
    {
        if (self.lblProductPrice.text.length > 0 && self.lblProductTitle.text.length > 0 && self.productImageView.image && self.currentCategoryId.length > 0 && self.lblEntries.text.length > 0)
        {
            if (!self.historySaved) {
                [self saveHistory];
            }
            [self.lblProductPrice setHidden:NO];
            [self.lblProductTitle setHidden:NO];
            [self.productImageView setHidden:NO];
            [self.lblEntries setHidden:NO];
            self.lblRecommendedPrice.text = [NSString stringWithFormat:@"Recommended selling price: %@", [self getRecommendedPrice]];
            [self.lblRecommendedPrice setHidden:NO];
            [self.btnEbay setHidden:NO];
            [self.btnRestart setHidden:NO];
            [self.activityIndicator stopAnimating];
        }
    }
    
}

- (void)saveHistory {
    self.historySaved = YES;
    NSMutableArray *arrayHistory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"History"]];
    NSData *imgData = UIImagePNGRepresentation(self.productImageView.image);
    NSDictionary *mostRecent = [NSDictionary dictionaryWithObjectsAndKeys:self.iSBN, @"ISBN", self.lblProductTitle.text, @"Title", imgData, @"Image", nil];
    [arrayHistory addObject:mostRecent];
    [[NSUserDefaults standardUserDefaults] setObject:arrayHistory forKey:@"History"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)getRecommendedPrice {
    float fractionOff = 0;
    if (self.entries > 10) {
        fractionOff = .05;
    }
    else if (self.entries > 5) {
        fractionOff = .15;
    }
    else if (self.entries > 2) {
        fractionOff = .22;
    }
    else {
        fractionOff = .30;
    }
    float price = self.price - (self.price * fractionOff);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *priceWithCommas = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    return [NSString stringWithFormat:@"$%@ USD", priceWithCommas];
    
}

- (void)animateIn:(UIView *)view {
    [view setHidden:NO];
    [UIView animateWithDuration:.3 animations:^{
        [view setAlpha:1];
    }];
}

- (void)animateOut:(UIView *)view andRemove:(BOOL)remove {
    [UIView animateWithDuration:.3 animations:^{
        [view setAlpha:0];
    } completion:^(BOOL finished) {
        [view setHidden:YES];
        if (remove) {
            [view removeFromSuperview];
        }
    }];
}

- (void)onTapButtonHistory {
    [self animateOut:self.btnHistory andRemove:NO];
    [self animateOut:self.contentView andRemove:NO];
    [self animateIn:self.btnCancel];
    [self animateIn:self.btnClearHistory];
    NSMutableArray *arrayHistory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"History"]];
    self.historyViewController = [[HistoryViewController alloc] initWithHistory:arrayHistory delegate:self frame:CGRectMake(0, self.contentView.frame.origin.y, self.view.frame.size.width, self.contentView.frame.size.height-self.btnCancel.frame.size.height-20)];
    [self.historyViewController.view setAlpha:0];
    [self.view addSubview:self.historyViewController.view];
    [self animateIn:self.historyViewController.view];
    
}

- (void)onTapButtonCancel {
    [self animateOut:self.btnCancel andRemove:NO];
    [self animateOut:self.btnClearHistory andRemove:NO];
    [self animateOut:self.historyViewController.view andRemove:YES];
    [self animateIn:self.btnHistory];
    [self animateIn:self.contentView];
    
}

- (void)onTapButtonClearHistory {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear History" message:@"Are you sure you would like to clear your history?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clear = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"History"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.historyViewController.arrayHistory = nil;
        [self.historyViewController.tableView reloadData];
    }];
    [alertController addAction:clear];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)onTapButtonEbay {
    NSString *urlString = [NSString stringWithFormat:@"http://csr.ebay.com/sell/list.jsf?usecase=create&mode=AddItem&categoryId=%@&rp=srp&title=%@", self.currentCategoryId, self.lblProductTitle.text];
    NSString *urlStringHtml = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!self.ebayView)
    {
        CGRect rect = CGRectMake(25, self.view.frame.size.width/12, self.view.frame.size.width - 50, self.view.frame.size.height / 2);
        self.backView = [[BackView alloc] init];
        self.ebayView = [[EbayView alloc] initWithFrame:rect url:urlStringHtml];
        self.ebayView.delegate = self;
        [self.view addSubview:self.backView];
        [self.view addSubview:self.ebayView];
    }
    else
    {
        [self.ebayView relaodUrl:urlStringHtml];
        [self.backView show];
        [self.ebayView show];
    }
    
}

- (void)onTapButtonRestart {
    self.checkingPriceIsDisabled = NO;
    [self setItemInfoHidden:YES];
    
}

- (void)loadInformationForISBN:(NSString *)iSBN {
    [self onTapButtonCancel]; //ensure it is on content view
    self.checkingPriceIsDisabled = YES;
    [self setItemInfoHidden:YES];
    [self.activityIndicator startAnimating];
    self.lblDigits.text = iSBN;
    EBayAPIHandler *eBayAPIHandlerGeneric = [[EBayAPIHandler alloc] init];
    [eBayAPIHandlerGeneric getGenericInformationForISBN:iSBN];
    eBayAPIHandlerGeneric.delegate = self;
    EBayAPIHandler *eBayAPIHandlerPricing = [[EBayAPIHandler alloc] init];
    [eBayAPIHandlerPricing getPricingInformationForISBN:iSBN];
    eBayAPIHandlerPricing.delegate = self;
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
                [self.cam stop];
                break;
            }
        }
        
        if (detectionString != nil && !self.checkingPriceIsDisabled)
        {
            self.iSBN = detectionString;
            [self loadInformationForISBN:(NSString *)detectionString];
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

- (void)getEbayTotalEntries:(int)entries {
    self.entries = entries;
    self.lblEntries.text = [NSString stringWithFormat:@"Listing count: %d", entries];
    [self setItemInfoHidden:NO];
}

- (void)ebayViewDidDismiss
{
    [_backView hide];
}

- (void)historyView:(HistoryViewController *)controller didSelectISBN:(NSString *)iSBN {
    [self loadInformationForISBN:iSBN];
}

@end
