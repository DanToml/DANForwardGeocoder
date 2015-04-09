//
//  DANForwardGeocoderAddressComponent.m
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import "DANForwardGeocoderAddressComponent.h"

@implementation DANForwardGeocoderAddressComponent

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.shortName = [aDecoder decodeObjectForKey:@"shortName"];
        self.longName = [aDecoder decodeObjectForKey:@"longName"];
        self.types = [aDecoder decodeObjectForKey:@"types"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.shortName) {
        [aCoder encodeObject:self.shortName forKey:@"shortName"];
    }
    if (self.longName) {
        [aCoder encodeObject:self.longName forKey:@"longName"];
    }
    if (self.types) {
        [aCoder encodeObject:self.types forKey:@"types"];
    }
}

@end
