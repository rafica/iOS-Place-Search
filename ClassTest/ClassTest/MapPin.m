//
//  MapPin.m
//  ClassTest
//
//  Created by rafica on 2/9/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//
#import "MapPin.h"

@implementation MapPin
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize url = _url;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate type:(NSString *)type rating:(NSString *)rating url:(NSString *)url{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _rating = [rating copy];
        _type = [type copy];
        _url = [url copy];
        
    }
    return self;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

-(NSString *)subtitle {
    return _address;
}

@end