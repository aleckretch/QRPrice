//
//  HistoryTableViewCell.m
//  QRPrice
//
//  Created by Alec Kretch on 4/18/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

- (void)setNoHistory {
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 50);
    UILabel *lblHistory = [[UILabel alloc] initWithFrame:self.contentView.frame];
    lblHistory.textAlignment = NSTextAlignmentCenter;
    lblHistory.font = [UIFont fontWithName:@"OpenSans" size:14];
    lblHistory.text = @"No history yet.";
    [self.contentView addSubview:lblHistory];
    
}

- (void)setWithHistory:(NSDictionary *)history {
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 50);
    
    //add button to background
    self.btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnCell setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.btnCell setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    self.btnCell.exclusiveTouch = YES;
    [self.contentView addSubview:self.btnCell];
    
    NSData *imgData = [history objectForKey:@"Image"];
    UIImage *img = [UIImage imageWithData:imgData];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.height-20, self.contentView.frame.size.height-20)];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4.0;
    imageView.image = img;
    [self.contentView addSubview:imageView];
    
    NSString *title = [history objectForKey:@"Title"];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.y+imageView.frame.size.width+10, 10, self.contentView.frame.size.width-10-(imageView.frame.origin.y+imageView.frame.size.width+10), self.contentView.frame.size.height-20)];
    lblTitle.font = [UIFont fontWithName:@"OpenSans" size:14];
    lblTitle.text = title;
    [self.contentView addSubview:lblTitle];
    
}

- (void)performClearCell {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = self.btnCell.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
