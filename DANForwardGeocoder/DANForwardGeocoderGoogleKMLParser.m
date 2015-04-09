//
//  DANForwardGeocoderGoogleKMLParser.m
//  DANForwardGeocoder
//
//  Created by  Danielle Lancashireon 03/06/2014.
//  Copyright (c) 2014 Danielle Lancashire. All rights reserved.
//

#import "DANForwardGeocoderGoogleKMLParser.h"
#import "DANForwardGeocoderKMLResult.h"
#import "DANForwardGeocoderAddressComponent.h"
#import "DANForwardGeocoder.h"

@interface DANForwardGeocoderGoogleKMLParser ()
@property (nonatomic, assign, getter = isUsingAddressComponents) BOOL usingAddressComponents;

@property (nonatomic, strong) NSMutableArray *currentResults;
@property (nonatomic, strong) DANForwardGeocoderKMLResult *currentResult;
@property (nonatomic, strong) NSMutableArray *currentAddressComponents;
@property (nonatomic, strong) NSMutableArray *currentTypesArray;
@property (nonatomic, strong) DANForwardGeocoderAddressComponent *currentAddressComponent;
@property (nonatomic, strong) NSMutableString *contentsOfCurrentProperty;

@property (nonatomic, assign) BOOL currentPropertyIsLocation;
@property (nonatomic, assign) BOOL currentPropertyIsViewport;
@property (nonatomic, assign) BOOL currentPropertyIsBounds;
@property (nonatomic, assign) BOOL currentPropertyIsSouthWest;
@end

@implementation DANForwardGeocoderGoogleKMLParser

- (BOOL)parseXMLData:(NSData *)data error:(NSError *__autoreleasing *)error ignoreAddressComponents:(BOOL)ignore
{
    BOOL successful = YES;
    
    self.usingAddressComponents = !ignore;
    
	// Create XML parser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
    // Start parsing
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		
		successful = NO;
    }
    
    return successful;
}

- (NSArray *)results
{
    return [self.currentResults copy];
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSString *parseElementName = qName ?: elementName;
    
    // Start of a placemark element
    if ([parseElementName isEqualToString:@"result"]) {
        
        if (self.currentResults == nil) {
            
            self.currentResults = [[NSMutableArray alloc] init];
        }
        
        self.currentResult = [[DANForwardGeocoderKMLResult alloc] init];
        
        self.currentPropertyIsBounds = NO;
        self.currentPropertyIsViewport = NO;
        self.currentPropertyIsLocation = NO;
        self.currentPropertyIsSouthWest = NO;
    } else if (self.isUsingAddressComponents && [parseElementName isEqualToString:@"address_component"]) {
        
        if (!!!self.currentAddressComponents) {
            
            self.currentAddressComponents = [NSMutableArray array];
        }
        
        self.currentAddressComponent = [[DANForwardGeocoderAddressComponent alloc] init];
        self.currentTypesArray = [NSMutableArray array];
    } else if([parseElementName isEqualToString:@"location"]) {
        
		self.currentPropertyIsLocation = YES;
	} else if([parseElementName isEqualToString:@"viewport"]) {
        
		self.currentPropertyIsViewport = YES;
	} else if([parseElementName isEqualToString:@"bounds"]) {
        
		self.currentPropertyIsBounds = YES;
	} else if([parseElementName isEqualToString:@"southwest"]) {
        
		self.currentPropertyIsSouthWest = YES;
	}
    
    NSArray *requiredKeys = @[@"status", @"formatted_address", @"lat", @"lng"];
    NSArray *addressComponentKeys = @[@"type", @"long_name", @"short_name"];

	if ([requiredKeys containsObject:parseElementName] ||
        (self.isUsingAddressComponents && [addressComponentKeys containsObject:parseElementName])) {
        
		// Create a mutable string to hold the contents of the elements.
        // The content is collected in parser:foundCharacters:
        if (self.contentsOfCurrentProperty == nil) {
            
			self.contentsOfCurrentProperty = [NSMutableString string];
		} else {
            
			[self.contentsOfCurrentProperty setString:@""];
		}
	} else if (self.contentsOfCurrentProperty != nil) {
        
		// If we're not interested in the element we set the variable used
		// to collect information to nil.
		self.contentsOfCurrentProperty = nil;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *parseElementName = qName ?: elementName;
    
    // If it's the end of an element, add it to the results
    if ([parseElementName isEqualToString:@"result"]) {
        
        if (self.currentResult) {
            
            self.currentResult.addressComponents = self.currentAddressComponents;
            self.currentAddressComponents = nil;
            
            [self.currentResults addObject:self.currentResult];
            self.currentResult = nil;
        }
    } else if ([parseElementName isEqualToString:@"address_component"]) {
        
        if (self.currentAddressComponent) {
            
            self.currentAddressComponent.types = self.currentTypesArray;
            self.currentTypesArray = nil;
            
            [self.currentAddressComponents addObject:self.currentAddressComponent];
            self.currentAddressComponent = nil;
        }
    } else if ([parseElementName isEqualToString:@"location"]) {
        
        self.currentPropertyIsLocation = NO;
    } else if ([parseElementName isEqualToString:@"viewport"]) {
        
        self.currentPropertyIsViewport = NO;
    } else if ([parseElementName isEqualToString:@"southwest"]) {
        
        self.currentPropertyIsSouthWest = NO;
    }
    
    // If current property string is nil, then we don't care about it. Return early.
    if (!!!self.contentsOfCurrentProperty) {
        return;
    }
    
    NSString *elementValue = [self.contentsOfCurrentProperty copy];
    
    if ([parseElementName isEqualToString:@"status"]) {
        
        NSDictionary *mapping = @{@"OK": @(DANFGResponseStatusSuccess),
                                  @"ZERO_RESULTS": @(DANFGResponseStatusUnknownAddress),
                                  @"OVER_QUERY_LIMIT": @(DANFGResponseStatusTooManyRequests),
                                  @"REQUEST_DENIED": @(DANFGResponseStatusServerError),
                                  @"INVALID_REQUEST": @(DANFGResponseStatusBadRequest)};
        
        self.statusCode = ((NSNumber *)mapping[elementValue]).integerValue;
    } else if ([parseElementName isEqualToString:@"long_name"] && self.currentAddressComponent) {
        
        self.currentAddressComponent.longName = elementValue;
    } else if ([parseElementName isEqualToString:@"short_name"] && self.currentAddressComponent) {
        
        self.currentAddressComponent.shortName = elementValue;
    } else if ([parseElementName isEqualToString:@"type"]) {
        
        [self.currentTypesArray addObject:elementValue];
    } else if ([parseElementName isEqualToString:@"formatted_address"]) {
        
        self.currentResult.address = elementValue;
    } else if ([parseElementName isEqualToString:@"lat"]) {
        
        if (self.currentPropertyIsLocation) {
            
            self.currentResult.latitude = elementValue.doubleValue;
        } else if (self.currentPropertyIsViewport) {
            
            if (self.currentPropertyIsSouthWest) {
                
                self.currentResult.viewportSouthWestLatitude = elementValue.doubleValue;
            } else {
                
                self.currentResult.viewportNorthEastLatitude = elementValue.doubleValue;
            }
        } else if (self.currentPropertyIsBounds) {
            
            if (self.currentPropertyIsSouthWest) {
                
                self.currentResult.boundsSouthWestLat = elementValue.doubleValue;
            } else {
                
                self.currentResult.boundsNorthEastLat = elementValue.doubleValue;
            }
        }
    } else if ([parseElementName isEqualToString:@"lng"]) {
        
        if (self.currentPropertyIsLocation) {
            
            self.currentResult.longitude = elementValue.doubleValue;
        } else if (self.currentPropertyIsViewport) {
            
            if (self.currentPropertyIsSouthWest) {
                
                self.currentResult.viewportSouthWestLongitude = elementValue.doubleValue;
            } else {
                
                self.currentResult.viewportNorthEastLongitude = elementValue.doubleValue;
            }
        } else if (self.currentPropertyIsBounds) {
            
            if (self.currentPropertyIsSouthWest) {
                
                self.currentResult.boundsSouthWestLon = elementValue.doubleValue;
            } else {
                
                self.currentResult.boundsNorthEastLon = elementValue.doubleValue;
            }
        }
    }
    
    self.contentsOfCurrentProperty = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.contentsOfCurrentProperty) {
        
        [self.contentsOfCurrentProperty appendString:string];
    }
}

@end
