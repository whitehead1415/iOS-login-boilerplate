//
//  AuthenticationManager.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "NetCommunicator.h"
#import "NetCommunicatorDelegate.h"

@interface AuthenticationManager : NSObject <NetCommunicatorDelegate>

@property NSData *receivedData;
@property SEL currentSelector;
@property (nonatomic, assign) id delegate;




- (void)fetchSessionWithEmail:(NSString *)email password:(NSString *)password;
- (void)createNewUserWithName:(NSString *)name email:(NSString *)email password:(NSString *)password;
- (void)sessionWasFetched:(NSData *)data;
- (NetCommunicator *)netCommunicatorCreator;

@end
