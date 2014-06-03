//
//  DANForwardGeocoder.m
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import "DANForwardGeocoder.h"

const NSInteger DANForwardGeocoderRequestTimeoutInterval = 4 * 1000; // Timeout in milliseconds
#pragma mark - Private Categories

#pragma mark Coordinate Bounds to String

@interface DANForwardGeocoderCoordinateBounds (NSStringRepresentation)
/**
 *  NSString representing the bounding box with the format "(southWest latitude),(southWest longitude)|(northEast latitude),(northEast longitude)"
 */
@property (nonatomic, readonly) NSString *boundsString;

@end

@implementation DANForwardGeocoderCoordinateBounds (NSStringRepresentation)

- (NSString *)boundsString
{
    return [NSString stringWithFormat:@"%f,%f|%f,%f", self.southWest.latitude, self.southWest.longitude, self.northEast.latitude, self.northEast.longitude];
}

@end

#pragma mark String encoding

@interface NSString (DANFG_ENCODING)
@property (nonatomic, readonly) NSString *danfg_urlEncodedString;
@end

@implementation NSString (DANFG_ENCODING)

- (NSString *)danfg_urlEncodedString
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

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
    [[NSURLSession sharedSession] dataTaskWithRequest:[self URLRequestForURLString:[self URLStringForQuery:query]]
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        
                                    }];
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
