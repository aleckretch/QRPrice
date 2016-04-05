//
//  EbayCell.h
//  QRPrice
//
//  Created by Kyle Knez on 3/30/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EbayCell : UITableViewCell

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UILabel* titlelabel;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UIButton* ebayButton;

@end
