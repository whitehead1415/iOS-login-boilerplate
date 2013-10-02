//
//  SessionTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Session.h"

@interface SessionTests : XCTestCase

@end

@implementation SessionTests

Session *session;

- (void)setUp
{
    [super setUp];
    session = [[Session alloc] initWithEmail:@"testEmail" userId:@"testUserId" tokenId:@"testTokenId"];
}

- (void)tearDown
{
    session = nil;
    [super tearDown];
}

- (void)testSessionHasEmail
{
    XCTAssertEqualObjects(session.email, @"testEmail", @"Session should have email");
}

- (void)testSessionHasUserId
{
    XCTAssertEqualObjects(session.userId, @"testUserId", @"Session should have userId");
}

- (void)testSessionHasTokenId
{
    XCTAssertEqualObjects(session.tokenId, @"testTokenId", @"Session should have userId");
}


@end
