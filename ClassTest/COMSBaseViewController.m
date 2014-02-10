//
//  COMSBaseViewController.m
//  ClassTest
//
//  Created by William Falcon on 1/31/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "COMSBaseViewController.h"
#import <COMSMapManager/COMSMapManager.h>

@interface COMSBaseViewController ()

//private location manager
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *place;


@end

@implementation COMSBaseViewController

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
    NSLog(@"viewdidload");

    //self.place = @"Chipotle";
    //we must subscribe as the delegate to the location manager
    self.locationManager.delegate = self;
    
    //go ahead and start reading locations. The updates will come through the delegate methods
    [self.locationManager startUpdatingLocation];
    
    //make ourselves the delegate of the textfield so we can be notified of changes by it
    self.inputTextField.delegate = self;
    
    self.mapView.showsUserLocation = YES;
	// Do any additional setup after loading the view.
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

    firstLaunch = YES;

}

#pragma mark - Core location
/*
 Automatically called by location manager because we are it's delegate
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"didupdatelocations");
    //self.place = @"Chipotle";
    //extract the 2d coordinate for better readability
    CLLocation *loc = locations[0];
    CLLocationCoordinate2D coord = loc.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 2500, 2500);
    [self.mapView setRegion:region animated:YES];
    
    //query server for results
    //disabled because without API key, it will crash
    
    [GoogleMapManager nearestVenuesForLatLong:coord withinRadius:1200 forQuery:self.place queryType:@"Restaurant+hotel" googleMapsAPIKey:@"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ" searchCompletion:^(NSMutableArray *results) {
        
        [self plotPositions:results];
        
        
    
    }];
    
    
}





#pragma mark - UITextField delegate methods
/*
 Called by the textfield right before the text changes, great place to call a network for requests, etc... Here we'll use it to change the coor of the screen
 */
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //init colorseed in case the string length = 0
    char colorSeed = '\0';

    //if valid length, just grab the first character to seed our rgb value
    if (string.length>0) {
        colorSeed = [string characterAtIndex:0];
    }
    
    //generate random value between 0 and 255
    double blueValue = arc4random()%255;
    
    //create a color using rgb. Our R and B values come from the text and a random number
    UIColor *viewColor = [UIColor colorWithRed:colorSeed/255.0f green:0.0/255.0f blue:blueValue/255.0f alpha:1.0f];
    
    //apply the color to our view
    self.view.backgroundColor = viewColor;
    
    //I'm done, go ahead and make the change (if you say No, textfield won't change)
    return YES;
}
*/
#pragma mark - IBActions


-(void)plotPositions:(NSArray *)results {
    
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[results count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [results objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        // 5 - Create a new annotation.
        MapPin *placeObject = [[MapPin alloc] initWithName:name address:vicinity coordinate:placeCoord];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:placeObject];
        });
        
    }
    
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MapPin class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}


/*
 Actions when the main (only) button is pressed
 */

-(IBAction)updateLabelPressed:(UIButton *)sender {
    
    //set the display label text to that of the textfield
    self.place = self.inputTextField.text;
   
    [self removeMapViewAnnotations];
    
    
        //resign first responder (hide the keyboard)
    if (self.inputTextField.isFirstResponder) {
        [self.inputTextField resignFirstResponder];
    }
}

-(void)removeMapViewAnnotations{
    
    NSLog(@"updateLabel-removing annotations");
    
    NSInteger toRemoveCount = self.mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapView.annotations)
        if (annotation != self.mapView.userLocation)
            [toRemove addObject:annotation];
    [self.mapView removeAnnotations:toRemove];
}

/*
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didannotationviews");
    
    //Zoom back to the user location after adding a new set of annotations.
    
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    //If this is the first launch of the app then set the center point of the map to the user's location.
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}*/
/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}
*/


#pragma mark - Gesture recognizers
/*
 Actions when a certain view is tapped. In this case we added this recognizer to the main view (self.view) so that the keyboard will dismiss when the screen is tapped
 */
     

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"screentapped");
    //The textfield has a property called first responder. The keyboard is this textfields accessory view. When the textfield is in first responder mode, it means it is the primary focus on the screen (the textfield cursor is blinking, keyboard is up). To dismiss the keyboard, we tell it to resignFirstResponder status
    if (self.inputTextField.isFirstResponder) {
        [self.inputTextField resignFirstResponder];
    }
}







@end




