//
//  COMSBaseViewController.m
//  ClassTest
//
//  Created by William Falcon on 1/31/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "COMSBaseViewController.h"
#import <COMSMapManager/COMSMapManager.h>
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"

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


    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    //label.backgroundColor = [UIColor clearColor];
    //label.font = [UIFont boldSystemFontOfSize:20.0];
   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    //label.textColor = [UIColor blackColor]; // change this color
    //self.navigationItem.titleView = label;
    //label.text = @"Nearby Places";

    //[label sizeToFit];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    self.mapView.layer.borderWidth = 1.0;
    self.mapView.layer.borderColor = [[UIColor blackColor]CGColor];
    [self removeMapViewAnnotations];
    self.background2.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"brick-300x266.png"]];
    
    self.mapView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mapView.layer.shadowOpacity = 0.5;
    self.mapView.layer.shadowRadius = 3;
    self.mapView.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    
    //self.place = @"Chipotle";
    //we must subscribe as the delegate to the location manager
    self.locationManager.delegate = self;
    
    //go ahead and start reading locations. The updates will come through the delegate methods
    [self.locationManager startUpdatingLocation];
    
    
    //make ourselves the delegate of the mapview so we can be notified of changes by it
    self.mapView.delegate = self;
    
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

    [self.locationManager stopUpdatingLocation];    
    //self.place = @"Chipotle";
    //extract the 2d coordinate for better readability
    CLLocation *loc = locations[0];
    CLLocationCoordinate2D coord = loc.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 2500, 2500);
    [self.mapView setRegion:region animated:YES];
    
    //query server for results
    //disabled because without API key, it will crash
    
    [GoogleMapManager nearestVenuesForLatLong:coord withinRadius:1200 forQuery:self.place queryType:@"" googleMapsAPIKey:@"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ" searchCompletion:^(NSMutableArray *results) {
        

        if(!results||!results.count){
            //[self showAlert];
            
            alert= [[UIAlertView alloc] initWithTitle:@"No nearby places" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            NSLog(@"alert");
            [alert show];
            
            // NOT GETTING CALLED!!!!!!!!!!
            
        }
        else{
            [self plotPositions:results];
        }

    
    }];
    
    
}


#pragma mark - IBActions


-(void)plotPositions:(NSArray *)results {
    
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[results count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* places = [results objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [places objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[places objectForKey:@"name"];
        NSString *vicinity=[places objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        NSNumber *ratingn = [places objectForKey:@"rating"];
        //get the number for rating and convert to string format
        NSString *rating = [ratingn stringValue];
        
        
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
        
        //NSLog(@"%@",type);
        //NSLog(@"%@",rating);
        
        //Create a new annotation.
        MapPin *placeObject = [[MapPin alloc] initWithName:name address:vicinity coordinate:placeCoord type:type rating:rating url:url];
        
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
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightButton;
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





-(void)removeMapViewAnnotations{    

    
    NSInteger toRemoveCount = self.mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapView.annotations)
        if (annotation!= self.mapView.userLocation)
            [toRemove addObject:annotation];
    
    [self.mapView removeAnnotations:toRemove];
}

#pragma mark - Gesture recognizers
/*
 Actions when a certain view is tapped. In this case we added this recognizer to the main view (self.view) so that the keyboard will dismiss when the screen is tapped
 */


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

-(IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"screentapped");
    
}


@end




