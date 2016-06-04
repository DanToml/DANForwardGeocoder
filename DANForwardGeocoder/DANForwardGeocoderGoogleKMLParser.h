//
//  DANForwardGeocoderGoogleKMLParser.h
//  DANForwardGeocoder
//
//  Created by Danielle Lancashire on 03/06/2014.
//  Copyright (c) 2014 Danielle Lancashire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DANForwardGeocoderGoogleKMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, assign) NSInteger statusCode;
@property (readonly) NSArray *results;

- (BOOL)parseXMLData:(NSData *)data error:(NSError **)error ignoreAddressComponents:(BOOL)ignore;
@end
