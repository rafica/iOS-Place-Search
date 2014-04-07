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
    NSString *type;

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(touch.view.tag>=0){
        
            if(touch.view.tag == 0){
                self.barLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"bar";
            }
            
            else if (touch.view.tag==1){
                self.hospitalLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.barLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"hospital";
            }
            
            else if(touch.view.tag==2){
                self.policeLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.barLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"police";
            }
            
            else if(touch.view.tag==3){
                self.atmLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.barLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"atm";
            }
            else if(touch.view.tag==4){
                self.restaurantLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.barLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"restaurant";
            }
            else if(touch.view.tag==5){
                self.cafeLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.barLabel.backgroundColor = [UIColor clearColor];
                self.foodLabel.backgroundColor = [UIColor clearColor];
                type = @"cafe";
            }
            else if(touch.view.tag==6){
                self.foodLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:166.0/255.0 alpha:1.0];
                self.hospitalLabel.backgroundColor = [UIColor clearColor];
                
                self.policeLabel.backgroundColor = [UIColor clearColor];
                self.atmLabel.backgroundColor = [UIColor clearColor];
                self.restaurantLabel.backgroundColor = [UIColor clearColor];
                self.cafeLabel.backgroundColor = [UIColor clearColor];
                self.barLabel.backgroundColor = [UIColor clearColor];
                type = @"food";
            }
    }
    
}

- (IBAction)mainButtonPressed:(UIButton *)sender {
    
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Help" message:@"Tab1:Search, Tab2:List view, Tab3:Favorites" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert1 show];
    
}
- (IBAction)buttonDragged:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view.window];
    
    sender.view.center = CGPointMake(sender.view.center.x+translation.x, sender.view.center.y+translation.y);
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //modify button
    [self.helpButton.layer setCornerRadius:self.helpButton.frame.size.width/2];
    [self.helpButton.imageView.layer setCornerRadius:self.helpButton.frame.size.width/2];
    
    [self.helpButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    
    [self.helpButton.layer setBorderWidth:5.0f];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(buttonDragged:)];
    
    [self.helpButton addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]init];
    [self.gravity setAngle:M_PI/2 magnitude:3];
    [self.animator addBehavior:self.gravity];
    
    //add collision
    self.collision = [[UICollisionBehavior alloc]initWithItems:@[self.helpButton]];
    
    [self.animator addBehavior:self.collision];
    
    //launches something on delay
    double delayInSeconds = 2.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self.gravity addItem:self.helpButton];
    });
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    

    
    
    
    
    
    
    
    type = @"";
    
    
    // Input field color and corner radius
    [self.inputTextField.layer setCornerRadius:10.0f];
    [self.inputTextField setBackgroundColor:[UIColor colorWithRed:191.0/255.0 green:157.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    // Inner shadow for input text field
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:self.inputTextField.bounds];
    
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
    
    
    // Shadow effects and other UI for Search Button
    
    self.searchButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchButton.layer.shadowOpacity = 0.5;
    self.searchButton.layer.shadowRadius = 1;
    self.searchButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.searchButton.layer.cornerRadius = 7.0f;
    [self.searchButton setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
    
    // Setting background image
    self.background.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"brick-300x266.png"]];
    
    // Button press color changes
    [self.searchButton addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    
	// Do any additional setup after loading the view.
    //self.inputTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}



-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:195.0/255.0 green:131.0/255.0 blue:107.0/255.0 alpha:1.0]];
    sender.layer.shadowOffset= CGSizeMake(0, 0);
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
    sender.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

-(void)doSomething:(UIButton*)sender
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:187.0/255.0 blue:172.0/255.0 alpha:1.0]];
        sender.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    });
}

//Deciding whether to perform the segue.
//Checking if text field is empty

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([self.inputTextField.text isEqualToString:@""]){
        [self showAlert];   //if empty show alert
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
    mapObj.range = 200;
    mapObj.labelRange.text = @"200";
    //pass the data the user has just inputted. encode it for URL
    NSString* escapedUrlString =
    [self.inputTextField.text stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    mapObj.place = escapedUrlString;
    
    mapObj.queryType = type;
    
    
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
