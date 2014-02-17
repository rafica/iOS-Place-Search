//
//  DetailViewController.m
//  ClassTest
//
//  Created by rafica on 2/14/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    NSLog(@"initiwithnib");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameDetail.text = self.name;
    self.addressDetail.text = self.vicinity;
    self.typeDetail.text = self.type;
    if (self.rating) {
        self.ratingDetail.text = self.rating;
        self.ratingDetail.font= [UIFont fontWithName:@"Futura-Medium" size:17];
    }
    else{
        self.ratingDetail.font = [UIFont fontWithName:@"Futura-MediumItalic" size:17];
        self.ratingDetail.text = @"No rating";
 
    }
    
    if(self.vicinity) {
        self.addressDetail.text = self.vicinity;
        self.addressDetail.font= [UIFont fontWithName:@"Futura-Medium" size:17];
    }
    else{
        self.addressDetail.font = [UIFont fontWithName:@"Futura-MediumItalic" size:17];
        self.addressDetail.text = @"No details";
        
    }
    if(self.type){
        self.type = [self.type stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        self.type = [self.type stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.type substringToIndex:1] uppercaseString]];
        self.typeDetail.text = self.type;
        self.typeDetail.font= [UIFont fontWithName:@"Futura-Medium" size:17];
    }
    else{
        self.typeDetail.font = [UIFont fontWithName:@"Futura-MediumItalic" size:17];
        self.typeDetail.text = @"No details";
    }

    
    
    
    NSLog(@"%@",self.rating);

    
    if(self.url){
        NSURL *url = [NSURL URLWithString:self.url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        //CGSize size = img.size;
        //[self.imageDetail setImage:img];
        
        CGRect rect = CGRectMake(0,0,160,130);
        UIGraphicsBeginImageContext( rect.size );
        [img drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img1=[UIImage imageWithData:imageData];
        [self.imageDetail setImage:img1];
        
        self.imageDetail.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageDetail.layer.borderWidth = 1.0;
        
    }

    

    
    self.imageDetail.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageDetail.layer.shadowOffset = CGSizeMake(0, 5);
    self.imageDetail.layer.shadowOpacity = 2;
    self.imageDetail.layer.shadowRadius = 5.0;
    self.imageDetail.clipsToBounds = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
