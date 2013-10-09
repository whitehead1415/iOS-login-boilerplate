//
//  ResetPasswordViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/7/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

@synthesize emailField;
@synthesize codeField;
@synthesize passwordField;
@synthesize infoSwitch;
@synthesize infoLabel;
@synthesize msgLabel;
@synthesize submitBtn;

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

- (IBAction)toggleReset:(UISwitch *)sender {
    if (sender.on) {
        infoLabel.text = @"Get reset code";
        passwordField.enabled = NO;
        codeField.enabled = NO;
    
    }else {
        passwordField.enabled = YES;
        codeField.enabled =  YES;
        infoLabel.text = @"Reset password";
    }
}

- (IBAction)validate:(id)sender {
    msgLabel.text = @"";
    if (emailField.text.length < 1) {
        msgLabel.text = @"Please enter an email";
        return;
    }
    
    if (infoSwitch.on) {
        [self getResetCode];
    }else {
        if (codeField.text.length < 1) {
            msgLabel.text = @"Please enter the code from your email";
        }else if (passwordField.text.length < 1) {
            msgLabel.text = @"Please enter a new password";
        }else {
            [self resetPassword];
        }
    }
}

- (void)getResetCode {
    
}

- (void)resetPassword {
    
}

@end
