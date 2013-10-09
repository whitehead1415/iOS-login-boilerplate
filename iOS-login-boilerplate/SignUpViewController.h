//
//  SignUpViewController.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderViewController.h"
#import "AuthenticationManagerDelegate.h"
#import "AuthenticationManager.h"

@interface SignUpViewController : SliderViewController <AuthenticationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UISwitch *termsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

- (IBAction)signUp:(id)sender;
- (IBAction)goToTerms:(id)sender;
- (AuthenticationManager *)initializeAuthenticationManager;

@end
