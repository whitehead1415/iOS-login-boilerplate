//
//  ResetPasswordViewController.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/7/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderViewController.h"
#import "AuthenticationManagerDelegate.h"

@interface ResetPasswordViewController : SliderViewController <AuthenticationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *infoSwitch;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
- (IBAction)toggleReset:(UISwitch *)sender;
- (IBAction)validate:(UIButton *)sender;
- (void)getResetCode;
- (void)resetPassword;
@end
