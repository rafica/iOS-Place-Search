//
//  ListViewController.h
//  ClassTest
//
//  Created by rafica on 4/2/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COMSAppDelegate.h"
#import "DetailViewController.h"

@interface ListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    COMSAppDelegate *appDelegate;
}

@property NSMutableArray *sortedResults;

@end
