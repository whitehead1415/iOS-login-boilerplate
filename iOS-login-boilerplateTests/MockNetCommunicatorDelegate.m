//
//  MockNetCommunicatorDelegate.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/28/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "MockNetCommunicatorDelegate.h"

@implementation MockNetCommunicatorDelegate

@synthesize receivedData;
@synthesize error = _error;

- (void)fetchingDataSucceeded:(NSData *)data{
    receivedData = data;
}

- (void)fetchingDataFailed:(NSError *)error{
    _error = error;
}


@end
