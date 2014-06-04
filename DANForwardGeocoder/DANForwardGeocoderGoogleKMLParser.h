//
//  DANForwardGeocoderGoogleKMLParser.h
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DANForwardGeocoder.h"

@interface DANForwardGeocoderGoogleKMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, assign) NSInteger statusCode;
@property (readonly) NSArray *results;

- (BOOL)parseXMLData:(NSData *)data error:(NSError **)error ignoreAddressComponents:(BOOL)ignore;
@end
