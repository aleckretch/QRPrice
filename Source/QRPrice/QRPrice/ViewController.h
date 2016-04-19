//
//  ViewController.h
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CameraView.h"
#import "EBayAPIHandler.h"
#import "EbayView.h"
#import "HistoryViewController.h"
#import "BackView.h"

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, CameraViewDelegate, EBayAPIHandlerDelegate, EbayViewDelegate, HistoryViewControllerDelegate>

@property (retain, nonatomic) IBOutlet AVCaptureSession *session;
@property (retain, nonatomic) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;
@property (retain, nonatomic) IBOutlet HistoryViewController *historyViewController;
@property (retain, nonatomic) IBOutlet NSString *currentCategoryId;
@property (retain, nonatomic) IBOutlet NSString *iSBN;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIButton *btnClearHistory;
@property (retain, nonatomic) IBOutlet UIButton *btnEbay;
@property (retain, nonatomic) IBOutlet UIButton *btnHistory;
@property (retain, nonatomic) IBOutlet UIButton *btnRestart;
@property (retain, nonatomic) IBOutlet UILabel *lblDigits;
@property (retain, nonatomic) IBOutlet UILabel *lblEntries;
@property (retain, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (retain, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblRecommendedPrice;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *highlightView;
@property (retain, nonatomic) IBOutlet UIView *scannerView;

@property (assign, nonatomic) BOOL checkingPriceIsDisabled;
@property (assign, nonatomic) BOOL historySaved;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) int entries;

@end

