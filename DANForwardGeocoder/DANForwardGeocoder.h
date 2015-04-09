//
//  DANForwardGeocoder.h
//  DANForwardGeocoder
//
//  Created by  Danielle Lancashireon 03/06/2014.
//  Copyright (c) 2014 Danielle Lancashire. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef NS_ENUM(NSInteger, DANFGResponseStatus) {
    DANFGResponseStatusSuccess = 200,
    DANFGResponseStatusBadRequest = 400,
    DANFGResponseStatusServerError = 500,
    DANFGResponseStatusMissingQuery = 601,
    DANFGResponseStatusUnknownAddress = 602,
    DANFGResponseStatusUnavailableAddress = 603,
    DANFGResponseStatusUnkownDirections = 604,
    DANFGResponseStatusBadKey = 610,
    DANFGResponseStatusTooManyRequests = 620,
    DANFGResponseStatusNetworkError = 900
};

typedef void (^DANForwardGeocoderSuccess)(NSArray *results);
typedef void (^DANForwardGeocoderFailed)(DANFGResponseStatus status, NSString *errorMessage);

@class DANForwardGeocoder;

@interface DANForwardGeocoderCoordinateBounds : NSObject
- (instancetype)initWithSouthWest:(CLLocationCoordinate2D)southwest
                        northEast:(CLLocationCoordinate2D)northEast;

@property (nonatomic, assign, readonly) CLLocationCoordinate2D southWest;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D northEast;
@end

@interface DANForwardGeocoderQuery : NSObject
@property (nonatomic, copy) NSString *searchQuery;
@property (nonatomic, copy) NSString *regionBias;
@property (nonatomic, strong) DANForwardGeocoderCoordinateBounds *viewportBias;
@end

@interface DANForwardGeocoder : NSObject
- (instancetype)init;
- (void)forwardGeocodeWithQuery:(DANForwardGeocoderQuery *)query
                        success:(DANForwardGeocoderSuccess)success
                        failure:(DANForwardGeocoderFailed)failure;
@property (nonatomic, assign) BOOL useHTTP;
@end
