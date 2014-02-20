//
//  SearchViewController.h
//  ClassTest
//
//  Created by rafica on 2/10/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (strong, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *barLabel;

@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *policeLabel;
@property (weak, nonatomic) IBOutlet UILabel *atmLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;

@property (weak, nonatomic) IBOutlet UILabel *cafeLabel;

@property (weak, nonatomic) IBOutlet UILabel *foodLabel;


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
@end
