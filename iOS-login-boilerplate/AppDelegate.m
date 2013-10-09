//
//  AppDelegate.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//
//ICONS ARE FROM http://www.visualpharm.com
//

#import "AppDelegate.h"
#import "SliderMenuController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ResetPasswordViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenId = [defaults objectForKey:@"tokenId"];
    NSString *userId = [defaults objectForKey:@"userId"];
    NSString *email = [defaults objectForKey:@"email"];
    if (tokenId.length == 0 || userId.length == 0 || email.length == 0) {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginSliderMenuViewController"];
    }else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
