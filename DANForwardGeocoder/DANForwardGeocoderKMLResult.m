//
//  DANForwardGeocoderKMLResult.m
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import "DANForwardGeocoderKMLResult.h"
#import "DANForwardGeocoderAddressComponent.h"
#import <tgmath.h>

@implementation DANForwardGeocoderKMLResult

- (NSArray *)findAddressComponentsByTypeName:(NSString *)typeName
{
    NSMutableArray *matchingComponents = [NSMutableArray array];
    
    for (DANForwardGeocoderAddressComponent *addressComponent in self.addressComponents) {
        if (addressComponent.types) {
            for (NSString *type in addressComponent.types) {
                if ([type isEqualToString:typeName]) {
                    [matchingComponents addObject:addressComponent];
                    break;
                }
            }
        }
    }
    
    return [matchingComponents copy];
}

#pragma mark - Convenience Methods

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (MKCoordinateSpan)coordinateSpan
{
    // Calculate the difference between north east and south west to create a span
    CGFloat latitudeDelta = fabs(fabs(self.viewportNorthEastLatitude) - fabs(self.viewportSouthWestLatitude));
    CGFloat longitudeDelta = fabs(fabs(self.viewportNorthEastLongitude) - fabs(self.viewportSouthWestLongitude));
    
    return MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
}

- (MKCoordinateRegion)coordinateRegion
{
    return MKCoordinateRegionMake(self.coordinate, self.coordinateSpan);
}

@end
