//
//  LoginSliderMenuViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/8/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "LoginSliderMenuViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ResetPasswordViewController.h"

@interface LoginSliderMenuViewController ()

@end

@implementation LoginSliderMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithSliderViewControllers:[self getArrayOfSliderViewControllers]];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getArrayOfSliderViewControllers {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UIColor *darkBlue = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
    UIColor *lightBlue = [UIColor colorWithRed:109.0/255.0 green:188.0/255.0 blue:219.0/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:252.0/255.0 green:63.0/255.0 blue:73.0/255.0 alpha:1.0];
    
    UIImage *loginImage = [UIImage imageNamed:@"System-Login-icon.png"];
    UIImage *signUpImage = [UIImage imageNamed:@"Mathematic-Plus-icon.png"];
    UIImage *resetImage = [UIImage imageNamed:@"Buzz-Private-icon.png"];
    
    SliderMenuItem *loginItem = [[SliderMenuItem alloc] initWithImage:loginImage title:@"Login" color:darkBlue];
    SliderMenuItem *signUpItem = [[SliderMenuItem alloc] initWithImage:signUpImage title:@"Sign Up" color:red];
    SliderMenuItem *resetItem = [[SliderMenuItem alloc] initWithImage:resetImage title:@"Reset Password" color:lightBlue];
    
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    SignUpViewController *signUpVC = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    ResetPasswordViewController *resetVC = [storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    
    loginVC.sliderMenuItem = loginItem;
    signUpVC.sliderMenuItem = signUpItem;
    resetVC.sliderMenuItem = resetItem;
    
    NSArray *vcs = [[NSArray alloc] initWithObjects:loginVC, signUpVC, resetVC, nil];
    return vcs;
}

@end
