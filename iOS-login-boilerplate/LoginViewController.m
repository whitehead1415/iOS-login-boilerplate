//
//  LoginViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize msgLabel;
@synthesize emailField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    if (emailField.text.length == 0) {
        msgLabel.text = @"Please enter an email";
    }else if (passwordField.text.length == 0) {
        msgLabel.text = @"Please enter your password";
    }else {
        AuthenticationManager *authMan = [self initializeAuthenticationManager];
        [authMan fetchSessionWithEmail:emailField.text password:passwordField.text];
    }
}

- (void)didReceiveSession:(Session *)session message:(NSString *)message {
    [self performSegueWithIdentifier:@"homeSegue" sender:self];
}

- (void)fetchingDataFailedWithError:(NSError *)error {
    msgLabel.text = [error.userInfo objectForKey:@"printableError"];
}

- (AuthenticationManager *)initializeAuthenticationManager {
    return [[AuthenticationManager alloc] init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [passwordField becomeFirstResponder];
//    [passwordField setReturnKeyType:UIReturnKeyGo];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
