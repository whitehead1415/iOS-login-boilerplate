//
//  LoginViewController.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderViewController.h"
#import "KeychainItemWrapper.h"
#import "AuthenticationManager.h"
#import "AuthenticationManagerDelegate.h"

@interface LoginViewController : SliderViewController <AuthenticationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)login:(id)sender;
- (AuthenticationManager *)initializeAuthenticationManager;

@end
