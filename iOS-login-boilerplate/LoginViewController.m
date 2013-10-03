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
    msgLabel.text = @"";
    if (emailField.text.length == 0) {
        msgLabel.text = @"Please enter an email";
    }else if (passwordField.text.length == 0){
        msgLabel.text = @"Please enter your password";
    }else {
        AuthenticationManager *authMan = [self initializeAuthenticationManager];
        authMan.currentSelector = @selector(sessionWasFetched:);
        [authMan fetchSessionWithEmail:emailField.text password:passwordField.text];
    }
}

- (void)didReceiveSession:(Session *)session message:(NSString *)message {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:emailField.text accessGroup:nil];
    [keychainItem resetKeychainItem];
    [keychainItem setObject:emailField.text forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:passwordField.text forKey:(__bridge id)(kSecValueData)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:session.userId forKey:@"userId"];
    [defaults setObject:session.tokenId forKey:@"tokenId"];
    [defaults setObject:session.email forKey:@"email"];
    [self performSegueWithIdentifier:@"homeSegue" sender:self];
}

- (void)fetchingDataFailedWithError:(NSError *)error {
    msgLabel.text = [error.userInfo objectForKey:@"printableError"];
}

- (AuthenticationManager *)initializeAuthenticationManager {
    AuthenticationManager *authMan = [[AuthenticationManager alloc] init];
    authMan.delegate = self;

    return authMan;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (emailField.text.length != 0 && passwordField.text.length != 0) {
        [self login:nil];
        return YES;
    }
    
    if (textField == emailField) {
        [passwordField becomeFirstResponder];
    }else {
        [emailField becomeFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
