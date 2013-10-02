//
//  LoginViewControllerTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/1/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import <OCMock/OCMock.h>

@interface LoginViewControllerTests : XCTestCase

@end

@implementation LoginViewControllerTests

LoginViewController *controller;

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [controller view];
}

- (void)tearDown
{
    controller = nil;
    [super tearDown];
}

- (void)testMessageLabelIsConnected {
    XCTAssertNotNil(controller.msgLabel, @"The login label should be connected");
}

- (void)testLoginBtnIsConnected {
    XCTAssertNotNil(controller.loginBtn, @"LoginBtn should be present");
}

- (void)testSignUpBtnIsConnected {
    XCTAssertNotNil(controller.signUpBtn, @"LoginBtn should be present");
}

- (void)testEmailFieldIsConnected {
    XCTAssertNotNil(controller.emailField, @"LoginBtn should be present");
}

- (void)testPasswordFieldIsConnected {
    XCTAssertNotNil(controller.passwordField, @"LoginBtn should be present");
}

- (void)testMessageLabelIsEmptyString {
    XCTAssertEqualObjects(controller.msgLabel.text, @"", @"The label should be blank");
}

- (void)testLoginBtnAction {
    NSArray *buttonActions = [controller.loginBtn actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside];
    BOOL containsAction = [buttonActions containsObject:@"login:"];
    XCTAssertTrue(containsAction, @"There should be a login action connected to the button");
}

- (void)testLoginActionFailsWhenEmailFieldIsBlack {
    [controller login:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter an email", @"there should be an error msg when email is empty");
}

- (void)testLoginActionFailsWhenPasswordFieldIsBlank {
    controller.emailField.text = @"foo";
    [controller login:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter your password", @"there should be an error msg when email is empty");
}

- (void)testInitializeAuthenticationManager {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan isKindOfClass:[AuthenticationManager class]], @"AuthenticationManager should be initialized");
}

- (void)testLoginActionFailsWhenCredentialsAreInvalid {
    controller.emailField.text = @"invalidEmail";
    controller.passwordField.text = @"invalidPassword";
    id mockController = [OCMockObject partialMockForObject:controller];
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    [[authMan expect] fetchSessionWithEmail:[OCMArg any] password:[OCMArg any]];
    [controller login:nil];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Invalid email or password", @"printableError", nil];
    NSError *error = [[NSError alloc] initWithDomain:@"com.custom.domain" code:500 userInfo:userInfo];
    [controller fetchingDataFailedWithError:error];
    [authMan verify];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Invalid email or password", @"there should be an error when credentials are invalid");
}

- (void)testLoginActionSucceedsAndStoresUserInfo {
    controller.emailField.text = @"userEmail";
    controller.passwordField.text = @"userPassword";
    id mockController = [OCMockObject partialMockForObject:controller];
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    [[authMan expect] fetchSessionWithEmail:[OCMArg any] password:[OCMArg any]];
    [mockController login:nil];
    Session *session = [[Session alloc] initWithEmail:@"userEmail" userId:@"userId" tokenId:@"tokenId"];
    [mockController didReceiveSession:session message:@"success"];
    [[mockController expect] performSegueWithIdentifier:[OCMArg any] sender:[OCMArg any]];
    XCTAssertNoThrow([authMan verify], @"fetchSessionWithEmail should be called");
}


//- (void)testKeyboardDisapears {
//    
//}

@end
