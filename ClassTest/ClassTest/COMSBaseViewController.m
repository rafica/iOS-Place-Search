//
//  COMSBaseViewController.m
//  ClassTest
//
//  Created by rafica on 2/5/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "COMSBaseViewController.h"
#import <COMSMapManager/COMSMapManager.h>
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "ListViewController.h"

@interface COMSBaseViewController (){
    UIAlertView *alert;
}

//private location manager
@property (nonatomic, strong)CLLocationManager *locationManager;


@end



@implementation COMSBaseViewController

@synthesize place;

#pragma mark - Loading methods
/*
 Automatically called by the view controller
 */
-(void)awakeFromNib{
    
    //instantiate location manager
    self.locationManager = [CLLocationManager new];
    
}


/*
 Automatically called by the view controller
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.sharedProperty removeAllObjects];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    self.mapView.layer.borderWidth = 1.0;
    self.mapView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    //before loading remove all the pins
    [self removeMapViewAnnotations];
    
    //set background image
    self.background2.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"brick-300x266.png"]];
    
    
    //tried shadow for map.( for some reason not working)
    self.mapView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mapView.layer.shadowOpacity = 0.5;
    self.mapView.layer.shadowRadius = 3;
    self.mapView.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    

    //we must subscribe as the delegate to the location manager
    self.locationManager.delegate = self;
    
    //go ahead and start reading locations. The updates will come through the delegate methods
    [self.locationManager startUpdatingLocation];
    
    
    //make ourselves the delegate of the mapview so we can be notified of changes by it ( view for annotation gets called)
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

    //slider to change the range
   [self.rangeSlider addTarget:self action:@selector(mySliderChanged:) forControlEvents:UIControlEventValueChanged];

}

//selector function called when slider value changes

-(void)mySliderChanged:(UISlider*)slider{
    self.range = slider.value;
    self.labelRange.text = [[NSString alloc] initWithFormat:@"%d meters", (int)slider.value];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Core location
/*
 Automatically called by location manager because we are it's delegate
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    [self.locationManager stopUpdatingLocation];    

    //extract the 2d coordinate for better readability
    CLLocation *loc = locations[0];
    CLLocationCoordinate2D coord = loc.coordinate;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, self.range*2, self.range*2);
    [self.mapView setRegion:region animated:YES];
    
    //query server for results
 
    NSLog(@"%@", self.queryType);
    [GoogleMapManager nearestVenuesForLatLong:coord withinRadius:self.range forQuery:self.place queryType:self.queryType googleMapsAPIKey:@"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ" searchCompletion:^(NSMutableArray *results) {
        //if no results show Alert. else plot in the map
        if(!results||!results.count){
            alert= [[UIAlertView alloc] initWithTitle:@"No nearby places" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            [self plotPositions:results location:loc];
            
        }
    }];
    
    
}


-(void)plotPositions:(NSMutableArray *)results location:(CLLocation *)currentloc{
    
    // Loop through the array of places returned from the Google API.

    
    NSMutableArray *changedResults = [[NSMutableArray alloc]init];
    //NSLog(@"%@",changedResults);
    
    NSLog(@"plot");
    
    for (int i=0; i<[results count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSMutableDictionary* places = [NSMutableDictionary dictionaryWithDictionary:[results objectAtIndex:i]];
        // There is a specific NSDictionary object that gives us the location info.
        NSMutableDictionary *geo = [places objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSMutableDictionary *loc = [geo objectForKey:@"location"];
        // Get your name and address info for adding to a pin.
        NSString *name=[places objectForKey:@"name"];
        NSString *vicinity=[places objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        CLLocation *placeLoc = [[CLLocation alloc]initWithLatitude:placeCoord.latitude longitude:placeCoord.longitude];
        CLLocationDistance meters = [placeLoc distanceFromLocation:currentloc];
        
        
        NSNumber *distance = [[NSNumber alloc]initWithDouble:meters];
        [places setObject:distance forKey:@"distance"];
        //NSLog(@"%@",places);
        [changedResults addObject:places];
       // NSLog(@"%@",listObj.sortedResults);
        
        NSNumber *ratingn = [places objectForKey:@"rating"];
        //get the number for rating and convert to string format
        NSString *rating = [ratingn stringValue];
        
        //get the first type from the array of types
        NSArray *typeArray = [places objectForKey:@"types"];
        NSString *type = typeArray[0];
        
        NSDictionary *photoDict = [[places objectForKey:@"photos"] objectAtIndex:0];
        NSString *photoRef = [photoDict objectForKey:@"photo_reference"];
        NSString *url;
        if(photoRef){
            url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?photoreference=%@&key=%@&sensor=false&maxwidth=320", photoRef, @"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ"];
        }
        else{
            url = NULL;
        }

        
        //Create a new annotation.
        MapPin *placeObject = [[MapPin alloc] initWithName:name address:vicinity coordinate:placeCoord type:type rating:rating url:url];

        //Loop through all pins already in the map and check if the new pin is already pinned.
        // If its not pinned, then pin it
        
        int flag = 0;
        for (MapPin *existingPin in self.mapView.annotations)
        {
            // If the pin is of MKUserLocation, then the pin is the CurrentLocation pin which should be ignored
            if ([existingPin isMemberOfClass:[MKUserLocation class]]){
                continue;
            }
            
            if (([[existingPin.name lowercaseString] isEqualToString:[placeObject.name lowercaseString]]) &&
                 (existingPin.coordinate.latitude == placeObject.coordinate.latitude) &&
                 (existingPin.coordinate.longitude == placeObject.coordinate.longitude))
                {
                    flag = 1;
                    break;
                }

        }
        
        if(flag==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:placeObject]; //this adds the pin to the map
            });
        }
        else{
            flag=0;
        }
        
        
    }
    
   
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    [changedResults sortUsingDescriptors:[NSArray arrayWithObjects:aSortDescriptor, nil]];
    

    appDelegate.sharedProperty = changedResults;
    NSLog(@"%@",changedResults);
    NSLog(@"results changed");
}

//gets called when a pin is added

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
   
    if ([annotation isKindOfClass:[MapPin class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            //define the button type for detail disclosure of the annotation
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightButton;
            
        }
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}




// This function removes all the pins except the user location
-(void)removeMapViewAnnotations{
    NSInteger toRemoveCount = self.mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapView.annotations)
        if (annotation!= self.mapView.userLocation)
            [toRemove addObject:annotation];
    
    [self.mapView removeAnnotations:toRemove];
}

// called when the accessory control button is tapped

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Details" sender:view];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Details"])
    {
        DetailViewController *detailObj = ( DetailViewController * )segue.destinationViewController;
        MKAnnotationView *annotationView = sender;
        MapPin *annView =annotationView.annotation;
        detailObj.name = annView.name;
        detailObj.vicinity = annView.address;
        detailObj.type = annView.type;
        detailObj.rating = annView.rating;
        detailObj.url = annView.url;
    }
}


@end




