//
//  COMSBaseViewController.h
//  ClassTest
//
//  Created by William Falcon on 1/31/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"

//import the class where the CLLocationManagerDelegate protocol is implemented
@import CoreLocation;

//here between the <> we dictate what protocols we will implement. If we don't import the class that has that protocol declared, this won't work


@interface COMSBaseViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate>
{
    BOOL firstLaunch;
    int currenDist;
    CLLocationCoordinate2D currentCentre;
}
//connect our view controllers to the UIKit items on the storyboard
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
