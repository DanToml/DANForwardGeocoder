//
//  DANForwardGeocoderAddressComponent.h
//  DANForwardGeocoder
//
//  Created by  Danielle Lancashireon 03/06/2014.
//  Copyright (c) 2014 Danielle Lancashire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DANForwardGeocoderAddressComponent : NSObject<NSCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@property (nonatomic, copy) NSString *longName;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSArray *types;

@end
