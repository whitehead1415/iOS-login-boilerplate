//
//  AuthenticationManagerDelegate.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@protocol AuthenticationManagerDelegate <NSObject>

- (void) didReceiveSession:(Session *)session message:(NSString *)message;
- (void) fetchingDataFailedWithError:(NSError *)error;
- (void) resetCodeSuccessMessageWasReceived:(NSString *)msg;
@end
