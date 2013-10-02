//
//  MockNetCommunicatorDelegate.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunicatorDelegate.h"

@interface MockNetCommunicatorDelegate : NSObject <NetCommunicatorDelegate>

@property NSData *receivedData;
@property NSError *error;

@end
