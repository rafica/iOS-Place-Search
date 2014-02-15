//
//  DetailViewController.h
//  ClassTest
//
//  Created by rafica on 2/14/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property NSString *name;
@property NSString *vicinity;
@property NSString *type;
@property NSString *rating;
@property NSString *url;

@property (weak, nonatomic) IBOutlet UILabel *nameDetail;
@property (weak, nonatomic) IBOutlet UILabel *addressDetail;
@property (weak, nonatomic) IBOutlet UILabel *typeDetail;
@property (weak, nonatomic) IBOutlet UILabel *ratingDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetail;

@end
