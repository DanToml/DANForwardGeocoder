//
//  DANForwardGeocoderKMLResult.m
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import "DANForwardGeocoderKMLResult.h"
#import "DANForwardGeocoderAddressComponent.h"

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

@end
