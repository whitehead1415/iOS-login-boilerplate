//
//  MockAuthenticationManagerDelegate.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationManagerDelegate.h"
#import "Session.h"

@interface MockAuthenticationManagerDelegate : NSObject <AuthenticationManagerDelegate>

@property Session *receivedSession;
@property NSString *receivedMessage;
@property NSError *receivedError;

@end
