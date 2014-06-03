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
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat viewportSouthWestLatitude;
@property (nonatomic, assign) CGFloat viewportSouthWestLongitude;
@property (nonatomic, assign) CGFloat viewportNorthEastLatitude;
@property (nonatomic, assign) CGFloat viewportNorthEastLongitude;
@property (nonatomic, assign) CGFloat boundsSouthWestLat;
@property (nonatomic, assign) CGFloat boundsSouthWestLon;
@property (nonatomic, assign) CGFloat boundsNorthEastLat;
@property (nonatomic, assign) CGFloat boundsNorthEastLon;

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MKCoordinateSpan coordinateSpan;
@property (readonly) MKCoordinateRegion coordinateRegion;

- (NSArray *)findAddressComponentsByTypeName:(NSString *)typeName;

@end
