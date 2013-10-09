//
//  HomeViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "HomeViewController.h"
#import "KeychainItemWrapper.h"
#import "SliderMenuController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ResetPasswordViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:email accessGroup:nil];
    [keychainItem resetKeychainItem];
    [defaults removeObjectForKey: @"userId"];
    [defaults removeObjectForKey: @"tokenId"];
    [defaults removeObjectForKey: @"email"];
    
    
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}

@end
