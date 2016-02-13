//
//  eBayAPIHandler.m
//  QRPrice
//
//  Created by Alec Kretch on 2/12/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "EBayAPIHandler.h"

@implementation EBayAPIHandler

- (void)getGenericInformationForISBN:(NSString *)iSBN {
    NSString *restCallString = [NSString stringWithFormat:@"http://open.api.ebay.com/shopping?callname=FindProducts&responseencoding=XML&appid=%@&siteid=0&version=525&productId.type=ISBN&productId.value=%@", EBAY_APP_NAME, iSBN];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    if (currentConnectionGeneric) //cancel current connections if there is one going on
    {
        [currentConnectionGeneric cancel];
        currentConnectionGeneric = nil;
        self.apiReturnXMLData = nil;
    }
    
    currentConnectionGeneric = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self]; //ignore deprecation for now
    self.apiReturnXMLData = [NSMutableData data];
    
}

- (void)getPricingInformationForISBN:(NSString *)iSBN {
    NSString *restCallString = [NSString stringWithFormat:@"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=%@&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&paginationInput.entriesPerPage=1&keywords=%@&sortOrder=PricePlusShippingLowest", EBAY_APP_NAME, iSBN];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    if (currentConnectionPricing) //cancel current connections if there is one going on
    {
        [currentConnectionPricing cancel];
        currentConnectionPricing = nil;
        self.apiReturnXMLData = nil;
    }
    
    currentConnectionPricing = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self]; //ignore deprecation for now
    self.apiReturnXMLData = [NSMutableData data];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary *)attributeDict {
    if (parser == xmlParserGeneric)
    {
        if ([elementName isEqualToString:@"Title"] || [elementName isEqualToString:@"StockPhotoURL"])
        {
            self.currentElement = [[NSString alloc] initWithString:elementName];
        }
    }
    else if (parser == xmlParserPricing)
    {
        if ([elementName isEqualToString:@"convertedCurrentPrice"]) //will always be USD
        {
            self.currentElement = [[NSString alloc] initWithString:elementName];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([self.currentElement isEqualToString:@"Title"])
    {
        [self.delegate getEbayProductTitle:string];
    }
    else if ([self.currentElement isEqualToString:@"StockPhotoURL"])
    {
        [self.delegate getEbayProductImageURL:string];
    }
    else if ([self.currentElement isEqualToString:@"convertedCurrentPrice"])
    {
        float price = [string floatValue];
        [self.delegate getEbayProductPrice:price];
    }
    self.currentElement = nil;
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    [self.apiReturnXMLData setLength:0];
    
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.apiReturnXMLData appendData:data];
    
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    if (connection == currentConnectionGeneric)
    {
        currentConnectionGeneric = nil;
    }
    else if (connection == currentConnectionPricing)
    {
        currentConnectionPricing = nil;
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == currentConnectionGeneric)
    {
        xmlParserGeneric = [[NSXMLParser alloc] initWithData:self.apiReturnXMLData];
        [xmlParserGeneric setDelegate:self];
        [xmlParserGeneric parse];
        
        currentConnectionGeneric = nil;
    }
    else if (connection == currentConnectionPricing)
    {
        xmlParserPricing = [[NSXMLParser alloc] initWithData:self.apiReturnXMLData];
        [xmlParserPricing setDelegate:self];
        [xmlParserPricing parse];
        
        currentConnectionPricing = nil;
    }
    
}


@end
