//
//  EbayCell.m
//  QRPrice
//
//  Created by Kyle Knez on 3/30/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "EbayCell.h"

@implementation EbayCell

@synthesize imageView = _imageView;
@synthesize priceLabel = _priceLabel;
@synthesize titlelabel = _titlelabel;
@synthesize ebayButton = _ebayButton;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
    }
    
    return self;
}


@end
