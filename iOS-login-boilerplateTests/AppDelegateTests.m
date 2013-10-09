//
//  AppDelegateTests.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 10/2/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginSliderMenuViewController.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests {
    UIWindow *window;
    UINavigationController *navigationController;
    AppDelegate *appDelegate;
    BOOL didFinishLaunchingWithOptionsReturn;
}

AppDelegate *appDelegate;

- (void)setUp
{
    [super setUp];
    window = [[UIWindow alloc] init];
    navigationController = [[UINavigationController alloc] init];
    appDelegate = [[AppDelegate alloc] init];
    appDelegate.window = window;
    didFinishLaunchingWithOptionsReturn = [appDelegate application: nil didFinishLaunchingWithOptions: nil];
}

- (void)tearDown
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    window = nil;
    navigationController = nil;
    appDelegate = nil;
    [super tearDown];
}

- (void)testLoginViewwControllerIsRootViewController {
    XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[LoginSliderMenuViewController class]], @"Login View should be shown");
}

- (void)testHomeViewControllerIsRootViewControllerIfCredentialsAreStored {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"testEmail" forKey:@"email"];
    [defaults setObject:@"testUserId" forKey:@"userId"];
    [defaults setObject:@"testTokenId" forKey:@"tokenId"];
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[HomeViewController class]], @"Home View should be shown");
}



@end
