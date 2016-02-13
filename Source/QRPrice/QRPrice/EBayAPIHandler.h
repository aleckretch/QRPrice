//
//  eBayAPIHandler.h
//  QRPrice
//
//  Created by Alec Kretch on 2/12/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface eBayAPIHandler : NSObject
{
    NSURLConnection *currentConnection;
}

@property (retain, nonatomic) NSMutableData *apiReturnXMLData;

@end
