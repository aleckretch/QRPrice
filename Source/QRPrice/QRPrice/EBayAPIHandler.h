//
//  eBayAPIHandler.h
//  QRPrice
//
//  Created by Alec Kretch on 2/12/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class EBayAPIHandler;

@protocol EBayAPIHandlerDelegate <NSObject>

- (void)getEbayProductTitle:(NSString *)title;
- (void)getEbayProductImageURL:(NSString *)url;
- (void)getEbayProductPrice:(float)price;

@end

@interface EBayAPIHandler : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>
{
    NSURLConnection *currentConnectionGeneric;
    NSURLConnection *currentConnectionPricing;
    NSXMLParser *xmlParserGeneric;
    NSXMLParser *xmlParserPricing;
}

@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@property (copy, nonatomic) NSString *currentElement;
@property (nonatomic, weak) id<EBayAPIHandlerDelegate> delegate;

- (void)getGenericInformationForISBN:(NSString *)iSBN;
- (void)getPricingInformationForISBN:(NSString *)iSBN;

@end
