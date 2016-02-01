//
//  ViewController.m
//  QRPrice
//
//  Created by Alec Kretch on 2/1/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayout];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setLayout {
    UIButton *btnQR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnQR setTitle:@"Check QR" forState:UIControlStateNormal];
    [btnQR sizeToFit];
    [btnQR setCenter:self.view.center];
    [btnQR addTarget:self action:@selector(onTapButtonQR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnQR];
    
}

- (void)onTapButtonQR {
    QRScannerViewController *qRScannerViewController = [[QRScannerViewController alloc] init];
    [self presentViewController:qRScannerViewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
