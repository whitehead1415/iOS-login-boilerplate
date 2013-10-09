//
//  logoutSegue.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/8/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "logoutSegue.h"

@implementation logoutSegue

- (void)perform
{
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
