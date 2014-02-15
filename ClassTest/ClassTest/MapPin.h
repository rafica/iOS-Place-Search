//
//  MapPin.h
//  ClassTest
//
//  Created by rafica on 2/9/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation>
{
    
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    NSString *_type;
    NSString *_rating;
    NSString *_url;
    
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy) NSString *type;
@property (copy) NSString *rating;
@property (copy) NSString *url;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate type:(NSString*)type rating:(NSString*)rating url:(NSString*)url;

@end
