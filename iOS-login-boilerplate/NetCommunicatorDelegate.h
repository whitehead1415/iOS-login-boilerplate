//
//  AuthenticationManagerDelegate.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetCommunicatorDelegate <NSObject>

- (void)fetchingDataSucceeded:(NSData *)data;
- (void)fetchingDataFailed:(NSError *)error;

@end
