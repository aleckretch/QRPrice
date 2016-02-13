//
//  eBayAPIHandler.m
//  QRPrice
//
//  Created by Alec Kretch on 2/12/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "eBayAPIHandler.h"

@implementation eBayAPIHandler

- (void)getGenericInformationForISBN:(NSString *)iSBN {
    NSString *restCallString = [NSString stringWithFormat:@"http://open.api.ebay.com/shopping?callname=FindProducts&responseencoding=XML&appid=%@&siteid=0&version=525&productId.type=ISBN&productId.value=%@", EBAY_APP_NAME, iSBN];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    if (currentConnection) //cancel current connections if there is one going on
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnXMLData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self]; //ignore deprecation for now
    self.apiReturnXMLData = [NSMutableData data];
    NSLog(@"data: %@", self.apiReturnXMLData);
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    [self.apiReturnXMLData setLength:0];
    
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    currentConnection = nil;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    currentConnection = nil;
    
}


@end
