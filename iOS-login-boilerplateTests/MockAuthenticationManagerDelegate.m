//
//  MockAuthenticationManagerDelegate.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "MockAuthenticationManagerDelegate.h"

@implementation MockAuthenticationManagerDelegate

@synthesize receivedSession;
@synthesize receivedMessage;
@synthesize receivedError;

- (void)didReceiveSession:(Session *)session message:(NSString *)message{
    receivedSession = session;
    receivedMessage = message;
}

- (void)fetchingDataFailedWithError:(NSError *)error {
    receivedError = error;
}

- (void)resetCodeSuccessMessageWasReceived:(NSString *)msg {
    receivedMessage = msg;
}

@end
