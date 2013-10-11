//
//  ResetPasswordViewControllerTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/8/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ResetPasswordViewController.h"
#import <OCMock/OCMock.h>


@interface ResetPasswordViewControllerTests : XCTestCase {
    ResetPasswordViewController *controller;
}

@end

@implementation ResetPasswordViewControllerTests

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    controller = [storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    [controller view];
}

- (void)tearDown {
    controller = nil;
    [super tearDown];
}

#pragma mark - Outlet Tests

- (void)testEmailFieldIsConnected {
    XCTAssertNotNil(controller.emailField, @"emailField should be connected");
}

- (void)testCodeFieldIsConnected {
    XCTAssertNotNil(controller.codeField, @"codeField should be connected");
}

- (void)testNewPasswordFieldIsConnected {
    XCTAssertNotNil(controller.passwordField, @"passwordField should be connected");
}

- (void)testInfoLabelIsConnected {
    XCTAssertNotNil(controller.infoLabel, @"infoLabel should be connected");
}

- (void)testMessageLabelIsConnected {
    XCTAssertNotNil(controller.msgLabel, @"msgLabel should be connected");
}

- (void)testInfoSwitchIsConnected {
    XCTAssertNotNil(controller.infoSwitch, @"infoSwitch should be connected");
}

- (void)testSubmitButtonIsConnected {
    XCTAssertNotNil(controller.submitBtn, @"submitBtn should be connected");
}

- (void)testSubmitBtnIsConnectedToValidateAction {
    NSArray *switchActions = [controller.submitBtn actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([switchActions containsObject:@"validate:"], @"Should be connected to validate Action");
}

#pragma mark - Toggle Get Reset/Recover Tests

- (void)testInfoSwitchIsConnectedToToggleResetAction {
    NSArray *switchActions = [controller.infoSwitch actionsForTarget:controller forControlEvent:UIControlEventValueChanged];
    XCTAssertTrue([switchActions containsObject:@"toggleReset:"], @"Should be connected to toggleReset Action");
}

- (void)testToggleResetActionEnablesFields {
    controller.infoSwitch.on = NO;
    [controller toggleReset:controller.infoSwitch];
    XCTAssertTrue(controller.passwordField.isEnabled, @"password field should be enabled");
    XCTAssertTrue(controller.codeField.isEnabled, @"code field should be enabled when infoSwitch is off");
}

- (void)testToggleResetActionChangesinfoLabelToRecover {
    controller.infoSwitch.on = NO;
    [controller toggleReset:controller.infoSwitch];
    XCTAssertEqualObjects(controller.infoLabel.text, @"Reset password", @"should be equal when infoSwitch is off");
}

- (void)testToggleResetActionDisablesFields {
    controller.passwordField.enabled = YES;
    controller.codeField.enabled = YES;
    controller.infoSwitch.on = YES;
    [controller toggleReset:controller.infoSwitch];
    XCTAssertFalse(controller.passwordField.isEnabled, @"password field should be enabled");
    XCTAssertFalse(controller.codeField.isEnabled, @"code field should be enabled when infoSwitch is off");
}

- (void)testToggleResetActionChangesinfoLabelToReset {
    controller.infoLabel.text = @"";
    controller.infoSwitch.on = YES;
    [controller toggleReset:controller.infoSwitch];
    XCTAssertEqualObjects(controller.infoLabel.text, @"Get reset code", @"should be equal when infoSwitch is off");
}

- (void)testMsgLabelIsClearedBeforeValidateAction {
    controller.msgLabel.text = @"foo";
    controller.emailField.text = @"bar";
    controller.passwordField.text = @"baz";
    [controller validate:nil];
    XCTAssertEqualObjects(controller.msgLabel.text, @"", @"The msgLabel should be reset");
}

#pragma mark - Get Reset Tests

- (void)testValidateFiresGetResetWhenInfoSwitchIsOn {
    controller.emailField.text = @"foo";
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] getResetCode];
    [controller validate:nil];
    XCTAssertNoThrow([mockController verify], @"should fire getResetCode");
}

- (void)testValidateSetsMsgLabelWhenEmailIsEmpty {
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] getResetCode];
    [controller validate:nil];
    XCTAssertThrows([mockController verify], @"should NOT fire getResetCode");
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter an email", @"should give error message");
}

- (void)testGetResetCodeFailsWhenEmailIsInvalid {
    controller.emailField.text = @"invalidEmail";
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    id mockController = [OCMockObject partialMockForObject:controller];
    id null = [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    null = nil;
    [[authMan expect] getResetCodeWithEmail:@"invalidEmail"];
    [[authMan expect] setCurrentSelector:@selector(resetCodeWasSent:)];
    [controller getResetCode];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email is invalid", @"printableError", nil];
    NSError *error = [[NSError alloc] initWithDomain:@"com.custom.domain" code:500 userInfo:userInfo];
    [controller fetchingDataFailedWithError:error];
    XCTAssertNoThrow([authMan verify], @"should call getResetCode");
    XCTAssertEqualObjects(controller.msgLabel.text, @"Email is invalid", @"The error message should be passed to the msgLabel");
}

- (void)testGetResetCodeSucceedsWhenEmailIsValid {
    NSString *successMsg = @"success";
    [controller resetCodeSuccessMessageWasReceived:successMsg];
    XCTAssertEqualObjects(controller.msgLabel.text, successMsg, @"success message should be passed to msgLabel");
}



#pragma mark - Reset Tests 

- (void)testValidateFiresResetPasswordWhenInfoSwitchIsOff {
    controller.emailField.text = @"foo";
    controller.codeField.text = @"bar";
    controller.passwordField.text = @"baz";
    controller.infoSwitch.on = NO;
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] resetPassword];
    [controller validate:nil];
    XCTAssertNoThrow([mockController verify], @"should fire getResetCode");
}

- (void)testValidateSetsMsgLabelWhenPasswordIsEmpty {
    controller.emailField.text = @"foo";
    controller.codeField.text = @"bar";
    controller.infoSwitch.on = NO;
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] resetPassword];
    [controller validate:nil];
    XCTAssertThrows([mockController verify], @"should NOT fire resetPassword");
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter a new password", @"should give error message when password is empty");
}
- (void)testValidateSetsMsgLabelWhenCodeIsEmpty {
    controller.emailField.text = @"foo";
    controller.infoSwitch.on = NO;
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] resetPassword];
    [controller validate:nil];
    XCTAssertThrows([mockController verify], @"should NOT fire resetPassword");
    XCTAssertEqualObjects(controller.msgLabel.text, @"Please enter the code from your email", @"should give error message when password is empty");
}

- (void)testResetPasswordFailsWhenEmailIsInvalid {
    controller.emailField.text = @"foo";
    controller.codeField.text = @"bar";
    controller.passwordField.text = @"baz";
    id authMan = [OCMockObject mockForClass:[AuthenticationManager class]];
    id mockController = [OCMockObject partialMockForObject:controller];
    id null = [[[mockController stub] andReturn:authMan] initializeAuthenticationManager];
    null = nil;
    [[authMan expect] resetPasswordWithCode:@"bar" email:@"foo" password:@"baz"];
    [[authMan expect] setCurrentSelector:@selector(sessionWasFetched:)];
    [controller resetPassword];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email is invalid", @"printableError", nil];
    NSError *error = [[NSError alloc] initWithDomain:@"com.custom.domain" code:500 userInfo:userInfo];
    [controller fetchingDataFailedWithError:error];
    XCTAssertNoThrow([authMan verify], @"should call getResetCode");
    XCTAssertEqualObjects(controller.msgLabel.text, @"Email is invalid", @"The error message should be passed to the msgLabel");
}

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

- (void)testKeyboardReturnKeyGoesToCodeFieldWhenCodeFieldIsEmpty {
    controller.infoSwitch.on = NO;
    id codeField = [OCMockObject partialMockForObject:controller.codeField];
    [[codeField expect] becomeFirstResponder];
    controller.codeField = codeField;
    [controller textFieldShouldReturn:controller.emailField];
    XCTAssertNoThrow([codeField verify], @"The passwordField should becomeFirstResponder");
}

- (void)testKeyboardReturnKeyGoesToEmailFieldWhenEmailField {
    controller.infoSwitch.on = NO;

    id emailField = [OCMockObject partialMockForObject:controller.emailField];
    [[emailField expect] becomeFirstResponder];
    controller.emailField = emailField;
    [controller textFieldShouldReturn:controller.passwordField];
    XCTAssertNoThrow([emailField verify], @"The emailField should becomeFirstResponder");
}

- (void)testKeyboardReturnKeyGoesToPasswordFieldWhenPasswordField {
    controller.infoSwitch.on = NO;

    id passwordField = [OCMockObject partialMockForObject:controller.passwordField];
    [[passwordField expect] becomeFirstResponder];
    controller.emailField = passwordField;
    [controller textFieldShouldReturn:controller.codeField];
    XCTAssertNoThrow([passwordField verify], @"The emailField should becomeFirstResponder");
}

- (void)testKeboardReturnKeyIsConnectedToValidateActionWhenFieldsAreNotEmpty {
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] validate:[OCMArg any]];
    controller.emailField.text = @"foo";
    [controller textFieldShouldReturn:controller.emailField];
    XCTAssertNoThrow([mockController verify], @"The validate action should be called when fields are not empty");
}

- (void)testKeboardReturnKeyIsConnectedToValidateActionWhenFieldsAreNotEmptyAndInfoSwitchIsNO {
    controller.infoSwitch.on = NO;
    id mockController = [OCMockObject partialMockForObject:controller];
    [[mockController expect] validate:[OCMArg any]];
    controller.emailField.text = @"foo";
    controller.passwordField.text = @"baz";
    controller.codeField.text = @"bar";
    [controller textFieldShouldReturn:controller.emailField];
    XCTAssertNoThrow([mockController verify], @"The validate action should be called when fields are not empty");
}

- (void)testInitializeAuthenticationManager {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan isKindOfClass:[AuthenticationManager class]], @"AuthenticationManager should be initialized");
}

- (void)testInitializeAuthenticationManagerSetsResetViewViewControllerAsDelegate {
    AuthenticationManager *authMan = [controller initializeAuthenticationManager];
    XCTAssertTrue([authMan.delegate isKindOfClass:[ResetPasswordViewController class]], @"Should set delegate as SignUpViewController");
}


@end
