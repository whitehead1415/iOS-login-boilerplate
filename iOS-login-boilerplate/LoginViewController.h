//
//  LoginViewController.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationManager.h"
#import "AuthenticationManagerDelegate.h"

@interface LoginViewController : UIViewController <AuthenticationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

- (IBAction)login:(id)sender;
- (AuthenticationManager *)initializeAuthenticationManager;

@end
