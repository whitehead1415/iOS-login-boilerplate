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

- (void)testLoginActionFailsWhenEmailIsEmpty {
    [controller login:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter an email", @"an error should show when email is blank");
}

- (void)testLoginActionFailsWhenPasswordIsEmpty {
    controller.emailField.text = @"foo";
    [controller login:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter your password", @"an error should show when password is blank");
}

- (void)testMsgLabelIsClearedBeforeLoginAction {
    controller.msgLabel.text = @"foo";
    controller.emailField.text = @"bar";
    controller.passwordField.text = @"baz";
    [controller login:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"", @"The msgLabel should be reset");
}

- (void)testInitializeAuthenticationManager {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan isKindOfClass:[AuthenticationManager class]], @"AuthenticationManager should be initialized");
}

- (void)testInitializeAuthenticationManagerSetsLoginViewControllerAsDelegate {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan.delegate isKindOfClass:[LoginViewController class]], @"Should set delegate as LoginViewController");
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
- (void)testLoginActionFailsWhenCredentialsAreInvalid {
    controller.emailField.text = @"invalidEmail";
    controller.passwordField.text = @"invalidPassword";
    id mockController = [OCMockObject partialMockForObject:controller];
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    [[authMan expect] setCurrentSelector:@selector(sessionWasFetched:)];
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
    [[authMan expect] setCurrentSelector:@selector(sessionWasFetched:)];
    [mockController login:nil];
    Session *session = [[Session alloc] initWithEmail:@"userEmail" userId:@"userId" tokenId:@"tokenId"];
    [mockController didReceiveSession:session message:@"success"];
    [[mockController expect] performSegueWithIdentifier:[OCMArg any] sender:[OCMArg any]];
    XCTAssertNoThrow([authMan verify], @"fetchSessionWithEmail should be called");
}

#pragma clang diagnostic pop

- (void)testLoginActionStoresEmailAndPassword {
    controller.emailField.text = @"testuser";
    controller.passwordField.text = @"testpassword";
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"testuser" accessGroup:nil];
    [controller didReceiveSession:nil message:nil];
    NSString *email = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    XCTAssertEqualObjects(email, @"testuser", @"The email should be stored");
    XCTAssertEqualObjects(password, @"testpassword", @"The password should be stored");
}

- (void)testLoginActionStoresSessionInNSUserDefaults {
    Session *session = [[Session alloc] initWithEmail:@"testUser" userId:@"testUserId" tokenId:@"testTokenId"];
    [controller didReceiveSession:session message:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    NSString *testUserId = [defaults objectForKey:@"userId"];
    NSString *testTokenId = [defaults objectForKey:@"tokenId"];
    XCTAssertEqualObjects(email, @"testUser", @"The email should be stored");
    XCTAssertEqualObjects(testUserId, @"testUserId", @"The userId should be stored");
    XCTAssertEqualObjects(testTokenId, @"testTokenId", @"The tokenId should be stored");
}

- (void)testTouchingOutSideOfKeyboardHidesKeyboard{
    id mockView = [OCMockObject partialMockForObject:controller.view];
    controller.view = mockView;
    [[mockView expect] endEditing:YES];
    [controller touchesBegan:nil withEvent:nil];
    XCTAssertNoThrow([mockView verify], @"The keyboard should be hidden on a touch event");
}

- (void)testKeyboardReturnKeyGoesToPasswordFieldWhenPasswordFieldIsEmpty {
    id passwordField = [OCMockObject partialMockForObject:controller.passwordField];
    [[passwordField expect] becomeFirstResponder];
    controller.passwordField = passwordField;
    [controller textFieldShouldReturn:controller.emailField];
    XCTAssertNoThrow([passwordField verify], @"The passwordField should becomeFirstResponder");
}

- (void)testKeyboardReturnKeyGoesToEmailFieldIfEmailFieldIsEmpty {
    id emailField = [OCMockObject partialMockForObject:controller.emailField];
    [[emailField expect] becomeFirstResponder];
    controller.emailField = emailField;
    [controller textFieldShouldReturn:controller.passwordField];
    XCTAssertNoThrow([emailField verify], @"The emailField should becomeFirstResponder");
}

- (void)testKeboardReturnKeyIsConnectedToLoginActionWhenFieldsAreNotEmpty {
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] login:[OCMArg any]];
    controller.emailField.text = @"foo";
    controller.passwordField.text = @"bar";
    [controller textFieldShouldReturn:controller.passwordField];
    XCTAssertNoThrow([mockController verify], @"The login action should be called when fields are not empty");
}

@end
