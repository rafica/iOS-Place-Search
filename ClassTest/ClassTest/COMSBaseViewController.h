//
//  COMSBaseViewController.h
//  ClassTest
//
//  Created by rafica on 2/5/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "COMSAppDelegate.h"

//import the class where the CLLocationManagerDelegate protocol is implemented
@import CoreLocation;

//here between the <> we dictate what protocols we will implement. If we don't import the class that has that protocol declared, this won't work


@interface COMSBaseViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    COMSAppDelegate *appDelegate;
    BOOL firstLaunch;
    int currenDist;
    CLLocationCoordinate2D currentCentre;
}
//connect our view controllers to the UIKit items on the storyboard


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *place;
@property (strong, nonatomic) IBOutlet UIView *background2;
@property double range;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;
@property (weak, nonatomic) IBOutlet UISlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelRange;

@property (weak, nonatomic) NSString *queryType;
@end
