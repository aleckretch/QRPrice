//
//  BackView.m
//  QRPrice
//
//  Created by Kyle Knez on 3/30/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "BackView.h"

@interface BackView()

@property CGPoint showPoint;
@property CGPoint hidePoint;

@end

@implementation BackView

-(instancetype)init
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self = [super initWithFrame: CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    if (self)
    {
        _showPoint = CGPointMake(0, 0);
        _hidePoint = CGPointMake(0, screenSize.height);
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ghost)]];
        self.alpha = 0.8;
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

-(void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(_showPoint.x, _showPoint.y, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(_hidePoint.x, _hidePoint.y, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)ghost
{
    // Do nothing
}


@end
