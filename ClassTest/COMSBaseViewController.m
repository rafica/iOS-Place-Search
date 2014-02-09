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

//@property (nonatomic,strong) NSMutableArray *nextAnnotations;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewwillappear");

    //self.place = @"Chipotle";
    //we must subscribe as the delegate to the location manager
    self.locationManager.delegate = self;
    
    //go ahead and start reading locations. The updates will come through the delegate methods
    [self.locationManager startUpdatingLocation];
    
    //make ourselves the delegate of the textfield so we can be notified of changes by it
    self.inputTextField.delegate = self;
    
    self.mapView.showsUserLocation = YES;
	// Do any additional setup after loading the view.
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
        
        
        
        
        CLLocationCoordinate2D location;                         // coordinates of the annotation
         // an array in which we'll save our annotations temporarily
        MKPointAnnotation *newAnnotation;                        // the pointer to the annotation we're adding
        
        
        
        for (NSDictionary *dictionary in results)
        {
            // retrieve latitude and longitude from the dictionary entry
            
            location.latitude = [[dictionary valueForKeyPath:@"geometry.location.lat"] doubleValue];
            location.longitude = [[dictionary valueForKeyPath:@"geometry.location.lng"] doubleValue];
            //NSLog(@"%@",[dictionary valueForKeyPath:@"geometry.location.lat"]);
            
            // create the annotation
            
            newAnnotation = [[MKPointAnnotation alloc] init];
            newAnnotation.title = dictionary[@"name"];
            newAnnotation.coordinate = location;
            NSLog(@"adding annotation");
            [self.mapView addAnnotation:newAnnotation];
            
            
        }
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

/*
 Actions when the main (only) button is pressed
 */

- (IBAction)updateLabelPressed:(UIButton *)sender {
    
    //set the display label text to that of the textfield
    self.place = self.inputTextField.text;
    NSLog(@"updateLabel-removing annotations");
    
    NSInteger toRemoveCount = self.mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapView.annotations)
        if (annotation != self.mapView.userLocation)
            [toRemove addObject:annotation];
    [self.mapView removeAnnotations:toRemove];
    
    
        //resign first responder (hide the keyboard)
    if (self.inputTextField.isFirstResponder) {
        [self.inputTextField resignFirstResponder];
    }
}

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








