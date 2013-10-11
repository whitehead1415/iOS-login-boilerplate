//
//  ResetPasswordViewController.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/7/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "HomeViewController.h"

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
    AuthenticationManager *authMan = [self initializeAuthenticationManager];
    authMan.currentSelector = @selector(resetCodeWasSent:);
    [authMan getResetCodeWithEmail:emailField.text];
}

- (void)resetPassword {
    AuthenticationManager *authMan = [self initializeAuthenticationManager];
    authMan.currentSelector = @selector(sessionWasFetched:);
    [authMan resetPasswordWithCode:codeField.text email:emailField.text password:passwordField.text];
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
    [self presentViewController:home animated:YES completion:NULL];
}

- (void)resetCodeSuccessMessageWasReceived:(NSString *)msg {
    msgLabel.text = msg;
}

- (void)fetchingDataFailedWithError:(NSError *)error {
    msgLabel.text = [error.userInfo objectForKey:@"printableError"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self textFieldsAreFilled]) {
        [self validate:nil];
    }else {
        [self setNextTextField:textField];
    }
    return YES;
}

- (BOOL)textFieldsAreFilled {
    if ((emailField.text.length < 1 || codeField.text.length < 1 || passwordField.text.length < 1) && !infoSwitch.isOn) {
        return NO;
    }else if(infoSwitch.isOn && emailField.text.length < 1) {
        return NO;
    }
    return YES;
}

- (void)setNextTextField:(UITextField *)textField {
    if (!infoSwitch.isOn) {
        if (textField == emailField) {
            [codeField becomeFirstResponder];
        }else if (textField == codeField) {
            [passwordField becomeFirstResponder];
        }else {
            [emailField becomeFirstResponder];
        }
    }
    
}

- (AuthenticationManager *)initializeAuthenticationManager {
    AuthenticationManager *authMan = [[AuthenticationManager alloc] init];
    authMan.delegate = self;
    return authMan;
}

@end
