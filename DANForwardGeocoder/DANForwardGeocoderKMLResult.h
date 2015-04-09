//
//  DANForwardGeocoderKMLResult.h
//  DANForwardGeocoder
//
//  Created by Daniel Tomlinson on 03/06/2014.
//  Copyright (c) 2014 Daniel Tomlinson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface DANForwardGeocoderKMLResult : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, copy) NSString *countryNameCode;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *subAdministrativeAreaName;
@property (nonatomic, copy) NSString *localityName;
@property (nonatomic, copy) NSArray *addressComponents;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double viewportSouthWestLatitude;
@property (nonatomic, assign) double viewportSouthWestLongitude;
@property (nonatomic, assign) double viewportNorthEastLatitude;
@property (nonatomic, assign) double viewportNorthEastLongitude;
@property (nonatomic, assign) double boundsSouthWestLat;
@property (nonatomic, assign) double boundsSouthWestLon;
@property (nonatomic, assign) double boundsNorthEastLat;
@property (nonatomic, assign) double boundsNorthEastLon;

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MKCoordinateSpan coordinateSpan;
@property (readonly) MKCoordinateRegion coordinateRegion;

- (NSArray *)findAddressComponentsByTypeName:(NSString *)typeName;

@end
