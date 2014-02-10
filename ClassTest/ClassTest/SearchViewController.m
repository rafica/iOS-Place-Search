//
//  SearchViewController.m
//  ClassTest
//
//  Created by rafica on 2/10/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "SearchViewController.h"
#import "COMSBaseViewController.h"

@interface SearchViewController ()


@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.inputTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    COMSBaseViewController * mapObj = ( COMSBaseViewController * )segue.destinationViewController;
    
    //next pass the data that the user has just inputted through the AddNewPresent_View.
    mapObj.place = self.inputTextField.text;
}
-(void)dismissKeyboard{
    [self.inputTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
