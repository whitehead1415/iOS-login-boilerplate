//
//  SignUpViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "KeychainItemWrapper.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize signUpBtn;
@synthesize emailField;
@synthesize nameField;
@synthesize passwordField;
@synthesize termsSwitch;
@synthesize msgLabel;
@synthesize termsBtn;
@synthesize termsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [msgLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)goToTerms:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.com"]];
}
- (IBAction)signUp:(id)sender {
    msgLabel.text = @"";
    if (nameField.text.length < 1) {
        msgLabel.text = @"Please enter a name";
    }else if (emailField.text.length <1){
        msgLabel.text = @"Please enter an email";
    }else if (passwordField.text.length < 1){
        msgLabel.text = @"Please enter a password";
    }else if (!termsSwitch.isOn){
        msgLabel.text = @"You must agree to the terms";
    }else {
        AuthenticationManager *authMan = [self initializeAuthenticationManager];
        authMan.currentSelector = @selector(sessionWasFetched:);
        [authMan createNewUserWithName:nameField.text email:emailField.text password:passwordField.text];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    HomeViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentViewController:home animated:YES completion:NULL];}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (emailField.text.length > 0 && passwordField.text.length > 0 && nameField.text.length > 0 && termsSwitch.isOn) {
        [self signUp:nil];
        return YES;
    }
    
    if (textField == nameField) {
        [emailField becomeFirstResponder];
    }else if (textField == emailField) {
        [passwordField becomeFirstResponder];
    }else  {
        [nameField becomeFirstResponder];
    }
    return YES;
}

- (void)fetchingDataFailedWithError:(NSError *)error {
    msgLabel.text = [error.userInfo objectForKey:@"printableError"];
}

- (AuthenticationManager *)initializeAuthenticationManager {
    AuthenticationManager *authMan = [[AuthenticationManager alloc] init];
    authMan.delegate = self;
    return authMan;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
