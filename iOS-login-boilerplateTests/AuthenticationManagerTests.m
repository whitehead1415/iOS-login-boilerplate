//
//  AuthenticationManagerTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AuthenticationManager.h"
#import "NetCommunicator.h"
#import "MockAuthenticationManagerDelegate.h"

@interface AuthenticationManagerTests : XCTestCase

@end

@implementation AuthenticationManagerTests

AuthenticationManager *authMan;
MockAuthenticationManagerDelegate *delegate;

- (void)setUp
{
    [super setUp];
    authMan = [[AuthenticationManager alloc] init];
    delegate = [[MockAuthenticationManagerDelegate alloc] init];
}

- (void)tearDown
{
    authMan = nil;
    delegate = nil;
    [super tearDown];
}

- (void)testNetCommunicatorCreatorReturnsNetCommunicatorInstance {
    NetCommunicator *testCommunicator = [authMan netCommunicatorCreator];
    XCTAssertTrue([testCommunicator isKindOfClass:[NetCommunicator class]], @"Should return NetCommunicator instance");
}

- (void)testNetCommunicatorCreatorSetsAuthenticationManagerAsDelegate {
    NetCommunicator *testCommunicator = [authMan netCommunicatorCreator];
    XCTAssertTrue([testCommunicator.delegate isKindOfClass:[AuthenticationManager class]], @"Should return NetCommunicator instance");
}


- (void)testFetchDataFromURLGetsCalled {
    NSString *responseString = @"{\"token\":{\"id\":\"testTokenId\",\"email\":\"testEmail\",\"userId\":\"testUserId\"}}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    id mockAuthenticationManager = [OCMockObject partialMockForObject:authMan];
    id netCommunicator = [OCMockObject mockForClass:[NetCommunicator class]];
    authMan.currentSelector = @selector(sessionWasFetched:);
    [[[mockAuthenticationManager stub] andReturn:netCommunicator] netCommunicatorCreator];
    [[netCommunicator expect] fetchDataFromURL:[OCMArg any] httpMethod:[OCMArg any] params:[OCMArg any]];
    [mockAuthenticationManager fetchingDataSucceeded:responseData];
    [authMan fetchSessionWithEmail:@"testEmail" password:@"testPassword"];
    XCTAssertNoThrow([netCommunicator verify], @"fetchDataFromURL should be called");
}

- (void)testCreateNewUserWithNameEmailAndPassword {
    NSString *responseString = @"{\"token\":{\"id\":\"testTokenId\",\"email\":\"testEmail\",\"userId\":\"testUserId\"}}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    id mockAuthenticationManager = [OCMockObject partialMockForObject:authMan];
    id netCommunicator = [OCMockObject mockForClass:[NetCommunicator class]];
    authMan.currentSelector = @selector(sessionWasFetched:);
    [[[mockAuthenticationManager stub] andReturn:netCommunicator] netCommunicatorCreator];
    [[netCommunicator expect] fetchDataFromURL:[OCMArg any] httpMethod:[OCMArg any] params:[OCMArg any]];
    [mockAuthenticationManager fetchingDataSucceeded:responseData];
    [authMan createNewUserWithName:@"foo" email:@"bar" password:@"baz"];
    XCTAssertNoThrow([netCommunicator verify], @"fetchDataFromURL should be called");

}

- (void)testCorrectMethodGetsCalledFromNetCommunicatorDelegate {
    NSString *responseString = @"{\"token\":{\"id\":\"testTokenId\",\"email\":\"testEmail\",\"userId\":\"testUserId\"}}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    id mockAuthenticationManager = [OCMockObject partialMockForObject:authMan];
    authMan.currentSelector = @selector(sessionWasFetched:);
    [[mockAuthenticationManager expect] sessionWasFetched:OCMOCK_ANY];
    [authMan fetchingDataSucceeded:responseData];
    XCTAssertNoThrow([mockAuthenticationManager verify], @"The sessionWasFetched should be called");
}

- (void)testSessionWasFetchedCreatesToken {
    NSString *responseString = @"{\"token\":{\"id\":\"testTokenId\",\"email\":\"testEmail\",\"userId\":\"testUserId\"}}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    authMan.delegate = delegate;
    [authMan sessionWasFetched:responseData];
    Session *testSession = [[Session alloc] initWithEmail:@"testEmail" userId:@"testUserId" tokenId:@"testTokenId"];
    XCTAssertEqualObjects(testSession.email, delegate.receivedSession.email, @"The emails should be the same");
    XCTAssertEqualObjects(testSession.userId, delegate.receivedSession.userId, @"The userIds should be the same");
    XCTAssertEqualObjects(testSession.tokenId, delegate.receivedSession.tokenId, @"The tokenIds should be the same");
}

- (void)testMessageIsReturnedOnSuccess {
    NSString *responseString = @"{\"token\":{\"id\":\"foo\",\"email\":\"bar\",\"userId\":\"baz\"},\"msg\":\"success\"}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    authMan.delegate = delegate;
    [authMan sessionWasFetched:responseData];
    XCTAssertEqualObjects(@"success", delegate.receivedMessage, @"The message should be passed to the delegate method");
}

- (void)testFetchingDataDidFailBecauseOfNetworkFailure {
    NSError *error = [[NSError alloc] initWithDomain:@"foobar" code:400 userInfo:nil];
    authMan.delegate = delegate;
    [authMan fetchingDataFailed:error];
    NSString *printableError = [delegate.receivedError.userInfo objectForKey:@"printableError"];
    NSString *errorString = @"Network connection failed. Please check network connection.";
    XCTAssertEqualObjects(errorString, printableError, @"The error from the communicator should be changed to something readable");
}

- (void)testFetchingDataDidFailedWithErrorBecauseOfMalformedJSON {
    NSData *responseData = [@"malformedJSON" dataUsingEncoding:NSUTF8StringEncoding];
    authMan.currentSelector = @selector(sessionWasFetched:);
    authMan.delegate = delegate;
    [authMan fetchingDataSucceeded:responseData];
    NSString *printableError = [delegate.receivedError.userInfo objectForKey:@"printableError"];
    XCTAssertEqualObjects(@"Unable to parse server response. Please do something!", printableError, @"The error should have printable text in userInfo");
}

- (void)testFetchingDataDidFailedWithErrorBecauseOfErrorSentFromServer {
    NSString *responseString = @"{\"error\":\"failure\"}";
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    authMan.delegate = delegate;
    [authMan sessionWasFetched:responseData];
    NSString *printableError = [delegate.receivedError.userInfo objectForKey:@"printableError"];
    XCTAssertEqualObjects(@"failure", printableError, @"The error should be the same as server error");
}


@end
