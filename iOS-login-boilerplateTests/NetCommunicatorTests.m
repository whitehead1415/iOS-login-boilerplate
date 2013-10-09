//
//  NetCommunicatorTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/27/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "NetCommunicator.h"
#import "MockNetCommunicatorDelegate.h"

@interface NetCommunicatorTests : XCTestCase

@end

@implementation NetCommunicatorTests

NetCommunicator *netCommunicator;

MockNetCommunicatorDelegate *delegate;

- (void)setUp
{
    [super setUp];
    netCommunicator = [[NetCommunicator alloc] init];
    delegate = [[MockNetCommunicatorDelegate alloc] init];
}

- (void)tearDown
{
    delegate = nil;
    netCommunicator = nil;
    [super tearDown];
}

- (void)testFetchDataFromURLReturnsData
{
    NSURLConnection *dummyUrlConnection = [[NSURLConnection alloc]
                                           initWithRequest:[NSURLRequest requestWithURL:
                                            [NSURL URLWithString:@""]] delegate:nil startImmediately:NO];
    
    NSData *responseData = [@"testString" dataUsingEncoding:NSUTF8StringEncoding];
    id partialMock = [OCMockObject partialMockForObject:netCommunicator];
    [[[partialMock stub] andReturn:dummyUrlConnection] newAsynchronousConnection:[OCMArg any]];
    netCommunicator.delegate = delegate;
    [netCommunicator fetchDataFromURL:[NSURL URLWithString:@"anyURL"] httpMethod:@"POST" params:nil];
    
    int statusCode = 200;
    id responseMock = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[responseMock stub] andReturnValue:OCMOCK_VALUE(statusCode)] statusCode];
    
    [netCommunicator connection:dummyUrlConnection didReceiveResponse:responseMock];
    [netCommunicator connection:dummyUrlConnection didReceiveData:responseData];
    [netCommunicator connectionDidFinishLoading:dummyUrlConnection];
    XCTAssertEqualObjects(delegate.receivedData, responseData, @"The result should be the same data that was given from the server");
}

- (void)testFetchDataFromURLFailsWithError{
    NSURLConnection *dummyUrlConnection = [[NSURLConnection alloc]
                                           initWithRequest:[NSURLRequest requestWithURL:
                                                            [NSURL URLWithString:@""]] delegate:nil startImmediately:NO];
    id partialMock = [OCMockObject partialMockForObject:netCommunicator];
    [[[partialMock stub] andReturn:dummyUrlConnection] newAsynchronousConnection:[OCMArg any]];
    netCommunicator.delegate = delegate;
    [netCommunicator fetchDataFromURL:[NSURL URLWithString:@"anyURL"] httpMethod:@"POST" params:nil];
    NSError *fakeError = [[NSError alloc] initWithDomain:@"fakeDomain" code:400 userInfo:nil];
    [netCommunicator connection:dummyUrlConnection didFailWithError:fakeError];
    XCTAssertEqualObjects(delegate.error, fakeError, @"The error should pass through to the netCommunicatorDelegate");
}

- (void)testNewAsynchronousConnectionReturnsNSURLConnection {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    NSURLConnection *connection = [netCommunicator newAsynchronousConnection:request];
    XCTAssertNotNil(connection, @"The connection should be non nil");
}

- (void)testNewAsynchronousRequestReturnsNSMutableURLRequest {
    NSURL *url = [NSURL URLWithString:@"anyURL"];
    NSMutableURLRequest *request = [netCommunicator newAsynchronousRequestWithURL:url];
    XCTAssertNotNil(request, @"The connection should be non nil");
}

- (void)testParametersGetSet {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@""]];
    id dummyRequest = [OCMockObject partialMockForObject:request];
    id partialMock = [OCMockObject partialMockForObject:netCommunicator];
    [[[partialMock stub] andReturn:dummyRequest] newAsynchronousRequestWithURL:[OCMArg any]];
    NSString *paramsString = @"foo=bar&test=test";
    NSData *paramsData = [NSData dataWithBytes:[paramsString UTF8String] length:paramsString.length];
    [[dummyRequest expect] setHTTPBody:paramsData];
    [netCommunicator fetchDataFromURL:[NSURL URLWithString:@"anyURL"] httpMethod:@"POST" params:paramsData];
    XCTAssertNoThrow([dummyRequest verify], @"should set parameters as body");
}

@end
