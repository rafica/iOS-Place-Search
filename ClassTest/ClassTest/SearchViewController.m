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

@interface SearchViewController (){

    UIAlertView *alert;

}


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
    

   
    [self.inputTextField.layer setCornerRadius:10.0f];
    [self.inputTextField setBackgroundColor:[UIColor colorWithRed:191.0/255.0 green:157.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:self.inputTextField.bounds];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:[[UIColor blackColor] CGColor]];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:4];
    
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.inputTextField.bounds, -42, -42));
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:self.inputTextField.bounds cornerRadius:10.0f].CGPath;
    CGPathAddPath(path, NULL, someInnerPath);
    CGPathCloseSubpath(path);
    
    [shadowLayer setPath:path];
    CGPathRelease(path);
    
    [[self.inputTextField layer] addSublayer:shadowLayer];
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    [maskLayer setPath:someInnerPath];
    [shadowLayer setMask:maskLayer];
    
    
    
    
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
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([self.inputTextField.text isEqualToString:@""]){
        [self showAlert];
        return NO;
    }
    return YES;
}

-(void) showAlert {
    alert = [[UIAlertView alloc] initWithTitle:@"Query empty" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    [self dismissAlert];
    //[alert dismissWithClickedButtonIndex:0 animated:TRUE];
}
-(void)dismissAlert  {
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
}
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
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
