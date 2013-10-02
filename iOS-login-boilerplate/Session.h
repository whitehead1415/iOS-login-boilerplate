//
//  Session.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property NSString *email;
@property NSString *userId;
@property NSString *tokenId;


- (Session *)initWithEmail:(NSString *)email userId:(NSString *)userId tokenId:(NSString *)tokenId;

@end
