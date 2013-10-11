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

- (void)testGetResetCodeWithEmailCallsFetchDataFromURL {
    id netCommunicator = [OCMockObject mockForClass:[NetCommunicator class]];
    id mockAuthMan = [OCMockObject partialMockForObject:authMan];
    [[[mockAuthMan stub] andReturn:netCommunicator] netCommunicatorCreator];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?email=%@", SERVER_URL, PASSWORD_ROUTE, @"foobar"]];
    [[netCommunicator expect] fetchDataFromURL:url httpMethod:@"GET" params:nil];
    [authMan getResetCodeWithEmail:@"foobar"];
    XCTAssertNoThrow([netCommunicator verify], @"getResetCodeWithEmail should call fetchDataFromURL");
}

- (void)testPasswordWithCodeCallsFetchDataFromURL {
    id netCommunicator = [OCMockObject mockForClass:[NetCommunicator class]];
    id mockAuthMan = [OCMockObject partialMockForObject:authMan];
    [[[mockAuthMan stub] andReturn:netCommunicator] netCommunicatorCreator];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@/%@?code=%@&email=%@&password=%@", SERVER_URL, PASSWORD_ROUTE, @"foo", @"bar", @"baz"]];
    [[netCommunicator expect] fetchDataFromURL:url httpMethod:@"PUT" params:nil];
    [authMan resetPasswordWithCode:@"foo" email:@"bar" password:@"baz"];
    XCTAssertNoThrow([netCommunicator verify], @"resetWithCode should call fetchDataFromURL");
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

- (void)testResetCodeWasSentGivesErrorBecauseOfInvalidJSON {
    NSString *jsonString = @"malformedJSON";
    NSData *jsonData = [NSData dataWithBytes:[jsonString UTF8String] length:jsonString.length];
    authMan.delegate = delegate;
    [authMan resetCodeWasSent:jsonData];
    NSString *error = [delegate.receivedError.userInfo objectForKey:@"printableError"];
    XCTAssertEqualObjects(@"Unable to parse server response. Please do something!", error, @"the fetchingDatFailedWithError should be called when json is malformed");
}

- (void)testResetCodeWasSentGivesErrorBecauseOfErrorFromServer {
    NSString *jsonString = @"{\"error\":\"failure\"}";
    NSData *jsonData = [NSData dataWithBytes:[jsonString UTF8String] length:jsonString.length];
    authMan.delegate = delegate;
    [authMan resetCodeWasSent:jsonData];
    NSString *error = [delegate.receivedError.userInfo objectForKey:@"printableError"];
    XCTAssertEqualObjects(@"failure", error, @"the fetchingDatFailedWithError should be called when server sends error");
}

- (void)testResetCodeWasSentCallsDelegateResetCodeSuccessMessageWasRecieved{
    NSString *jsonString = @"{\"msg\":\"success\"}";
    NSData *jsonData = [NSData dataWithBytes:[jsonString UTF8String] length:jsonString.length];
    authMan.delegate = delegate;
    [authMan resetCodeWasSent:jsonData];
    XCTAssertEqualObjects(delegate.receivedMessage, @"success", @"the resetCodeSuccessMessageWasReceived should be called when server sends message");
}



@end
