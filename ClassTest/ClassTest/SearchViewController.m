//
//  SearchViewController.m
//  ClassTest
//
//  Created by rafica on 2/10/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "SearchViewController.h"
#import "COMSBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

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

    [self.inputTextField.layer setCornerRadius:7.0f];
    [self.inputTextField setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:204.0/255.0 blue:191.0/255.0 alpha:1.0]];
    
    self.searchButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchButton.layer.shadowOpacity = 0.5;
    self.searchButton.layer.shadowRadius = 1;
    self.searchButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.searchButton.layer.cornerRadius = 7.0f;
    
    [self.searchButton setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
    self.background.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"brick-300x266.png"]];
    
    
    [self.searchButton addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    
	// Do any additional setup after loading the view.
    self.inputTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}

-(void)setBgColorForButton:(UIButton*)sender
{
    NSLog(@"press");
    [sender setBackgroundColor:[UIColor colorWithRed:195.0/255.0 green:131.0/255.0 blue:107.0/255.0 alpha:1.0]];
    sender.layer.shadowOffset= CGSizeMake(0, 0);
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    NSLog(@"back");
    [sender setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
    sender.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

-(void)doSomething:(UIButton*)sender
{
    NSLog(@"dosomething");
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
        sender.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    });
    
    //do something
    
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
