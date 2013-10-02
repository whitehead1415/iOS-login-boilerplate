//
//  Session.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "Session.h"

@implementation Session

- (Session *)initWithEmail:(NSString *)email userId:(NSString *)userId tokenId:(NSString *)tokenId{
    self = [super init];
    if (self) {
        self.email = email;
        self.userId = userId;
        self.tokenId = tokenId;
    }
    return self;
}

@end
