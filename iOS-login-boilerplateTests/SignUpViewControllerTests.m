//
//  SignUpViewControllerTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/3/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SignUpViewController.h"
#import <OCMock/OCMock.h>
#import "KeychainItemWrapper.h"
#import "AuthenticationManager.h"

@interface SignUpViewControllerTests : XCTestCase{
    SignUpViewController *controller;
}

@end

@implementation SignUpViewControllerTests

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    controller = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [controller view];

}

- (void)tearDown
{
    controller = nil;
    [super tearDown];
}

#pragma mark - Outlet Tests
- (void)testEmailFieldIsConnected {
    XCTAssertNotNil(controller.emailField, @"The email field should be connected");
}

- (void)testPasswordFieldIsConnected {
    XCTAssertNotNil(controller.passwordField, @"The password field should be connected");
}

- (void)testNameFieldIsConnected {
    XCTAssertNotNil(controller.nameField, @"The name field should be connected");
}

- (void)testMessageLabelIsConnected {
    XCTAssertNotNil(controller.msgLabel, @"The terms switch should be connected");
}

- (void)testTermsSwitchIsConnected {
    XCTAssertNotNil(controller.termsSwitch, @"The terms switch should be connected");
}

- (void)testTermsLabelIsConnected {
    XCTAssertNotNil(controller.termsLabel, @"The terms label should be connected");
}

- (void)testTermsBtnIsConnected {
    XCTAssertNotNil(controller.termsBtn, @"The termsBtn should be connected");
}

- (void)testSignUpBtnIsConnected {
    XCTAssertNotNil(controller.signUpBtn, @"The sign up button should be connected");
}

#pragma mark - Button Tests

- (void)testSignUpBtnIsConnectedToSignUpAction {
    NSArray *buttonActions = [controller.signUpBtn actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside];
    BOOL containsAction = [buttonActions containsObject:@"signUp:"];
    XCTAssertTrue(containsAction, @"There should be a login action connected to the button");
}

- (void)testTermsBtnIsConnectedToSignUpAction {
    NSArray *buttonActions = [controller.termsBtn actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside];
    BOOL containsAction = [buttonActions containsObject:@"goToTerms:"];
    XCTAssertTrue(containsAction, @"There should be a login action connected to the button");
}

#pragma mark - Action Tests

- (void)testSignUpActionFailsWhenNameIsEmpty {
    [controller signUp:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter a name", @"Should give error message when name is empty");
}

- (void)testSignUpActionFailsWhenEmailIsEmpty {
    controller.nameField.text = @"foo";
    [controller signUp:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter an email", @"Should give error message when email is empty");
}

- (void)testSignUpActionFailsWhenPasswordIsEmpty {
    controller.nameField.text = @"foo";
    controller.emailField.text = @"bar";
    [controller signUp:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter a password", @"Should give error message when password is empty");
}

- (void)testSignUpActionFailsWhenTermsSwitchIsNotEnabled {
    controller.nameField.text = @"foo";
    controller.emailField.text = @"bar";
    controller.passwordField.text = @"baz";
    controller.termsSwitch.on = NO;
    [controller signUp:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"You must agree to the terms", @"Should give error message when terms is not checked");
}

- (void)testMsgLabelIsWipedAtTheBeginingOfTheMethodCall {
    controller.nameField.text = @"foo";
    controller.emailField.text = @"bar";
    controller.passwordField.text = @"baz";
    controller.termsSwitch.on = YES;
    controller.msgLabel.text = @"NOT EMPTY!";
    [controller signUp:nil];
    [controller signUp:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"", @"The msgLabel should be reset");
}

- (void)testInitializeAuthenticationManager {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan isKindOfClass:[AuthenticationManager class]], @"AuthenticationManager should be initialized");
}

- (void)testInitializeAuthenticationManagerSetsLoginViewControllerAsDelegate {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan.delegate isKindOfClass:[SignUpViewController class]], @"Should set delegate as SignUpViewController");
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
- (void)testSignUpActionFailsWhenCredentialsAreInvalid {
    controller.emailField.text = @"duplicateEmail";
    controller.passwordField.text = @"password";
    controller.nameField.text = @"foobar";
    controller.termsSwitch.on = YES;
    id mockController = [OCMockObject partialMockForObject:controller];
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    [[authMan expect] setCurrentSelector:@selector(sessionWasFetched:)];
    [[authMan expect] createNewUserWithName:[OCMArg any] email:[OCMArg any] password:[OCMArg any]];
    [controller signUp:nil];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email is already in use", @"printableError", nil];
    NSError *error = [[NSError alloc] initWithDomain:@"com.custom.domain" code:500 userInfo:userInfo];
    [controller fetchingDataFailedWithError:error];
    [authMan verify];
    XCTAssertEqualObjects(controller.msgLabel.text, @"Email is already in use", @"there should be an error when credentials are invalid");
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

#pragma mark - Keyboard Tests

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
    [controller textFieldShouldReturn:controller.nameField];
    XCTAssertNoThrow([emailField verify], @"The emailField should becomeFirstResponder");
}

- (void)testKeyboardReturnKeyGoesToNameFieldIfNameFieldIsEmpty {
    id nameField = [OCMockObject partialMockForObject:controller.nameField];
    [[nameField expect] becomeFirstResponder];
    controller.nameField = nameField;
    [controller textFieldShouldReturn:controller.passwordField];
    XCTAssertNoThrow([nameField verify], @"The nameField should becomeFirstResponder");
}

- (void)testKeboardReturnKeyIsConnectedToLoginActionWhenFieldsAreNotEmpty {
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] signUp:[OCMArg any]];
    controller.emailField.text = @"foo";
    controller.passwordField.text = @"bar";
    controller.nameField.text = @"baz";
    controller.termsSwitch.on = YES;
    [controller textFieldShouldReturn:controller.passwordField];
    XCTAssertNoThrow([mockController verify], @"The signUp action should be called when fields are not empty");
}


@end
