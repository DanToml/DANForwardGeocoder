//
//  DANForwardGeocoder.m
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import "DANForwardGeocoder.h"
#import "DANForwardGeocoderGoogleKMLParser.h"

const NSInteger DANForwardGeocoderRequestTimeoutInterval = 4 * 1000; // Timeout in milliseconds

#pragma mark - Private Category Interfaces
@interface DANForwardGeocoderCoordinateBounds (NSStringRepresentation)
/**
 *  NSString representing the bounding box with the format "(southWest latitude),(southWest longitude)|(northEast latitude),(northEast longitude)"
 */
@property (nonatomic, readonly) NSString *boundsString;

@end


@interface NSString (DANFG_ENCODING)
@property (nonatomic, readonly) NSString *danfg_urlEncodedString;
@end

#pragma mark - DANForwardGeocoderCoordinateBounds

@implementation DANForwardGeocoderCoordinateBounds

- (instancetype)initWithSouthWest:(CLLocationCoordinate2D)southwest northEast:(CLLocationCoordinate2D)northEast
{
    self = [super init];
    if (self) {
        _southWest = southwest;
        _northEast = northEast;
    }
    
    return self;
}

@end

#pragma mark - DANForwardGeocoderQuery

@implementation DANForwardGeocoderQuery

@end

#pragma mark - DANForwardGeocoder

@interface DANForwardGeocoder ()
@property (nonatomic, copy) DANForwardGeocoderSuccess successBlock;
@property (nonatomic, copy) DANForwardGeocoderFailed failureBlock;
@end

@implementation DANForwardGeocoder

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)forwardGeocodeWithQuery:(DANForwardGeocoderQuery *)query
                        success:(DANForwardGeocoderSuccess)success
                        failure:(DANForwardGeocoderFailed)failure
{
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self URLRequestForURLString:[self URLStringForQuery:query]]
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         
                                         if (data) {
                                             
                                             DANForwardGeocoderGoogleKMLParser *parser = [[DANForwardGeocoderGoogleKMLParser alloc] init];
                                             [parser parseXMLData:data error:&error ignoreAddressComponents:NO];
                                             
                                             if (parser.statusCode == DANFGResponseStatusSuccess) {
                                                 
                                                 success(parser.results);
                                             } else if (failure) {
                                                 
                                                 failure(parser.statusCode, [error localizedDescription]);
                                             }
                                         } else if (failure) {
                                             
                                             failure(DANFGResponseStatusNetworkError, [error localizedDescription]);
                                         }
                                     }] resume];
}

#pragma mark - Private Methods

- (NSString *)URLStringForQuery:(DANForwardGeocoderQuery *)query
{
    NSMutableString *geocodedURLString = [NSString stringWithFormat:@"%@://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", (self.useHTTP ? @"http" : @"https"), query.searchQuery.danfg_urlEncodedString].mutableCopy;
    
    if (query.regionBias && ![query.regionBias isEqualToString:@""]) {
        [geocodedURLString appendFormat:@"&region=%@", query.regionBias];
    }
    
    if (query.viewportBias) {
        NSString *boundsString = query.viewportBias.boundsString.danfg_urlEncodedString;
        [geocodedURLString appendFormat:@"&bounds=%@", boundsString];
    }
    
    return geocodedURLString.copy;
}

- (NSURLRequest *)URLRequestForURLString:(NSString *)URLString
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]
                            cachePolicy:NSURLCacheStorageAllowed
                        timeoutInterval:DANForwardGeocoderRequestTimeoutInterval];
}

@end

#pragma mark - Private Category Implementation

#pragma mark Coordinate Bounds to String

@implementation DANForwardGeocoderCoordinateBounds (NSStringRepresentation)

- (NSString *)boundsString
{
    return [NSString stringWithFormat:@"%f,%f|%f,%f", self.southWest.latitude, self.southWest.longitude, self.northEast.latitude, self.northEast.longitude];
}

@end

#pragma mark String encoding

@implementation NSString (DANFG_ENCODING)

- (NSString *)danfg_urlEncodedString
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end