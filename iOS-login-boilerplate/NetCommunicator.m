//
//  NetCommunicator.m
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "NetCommunicator.h"
#import "NetCommunicatorDelegate.h"


@implementation NetCommunicator

@synthesize delegate;

- (NSURLConnection *)newAsynchronousRequest:(NSURLRequest *)request{
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)fetchDataFromURL:(NSURL *)url httpMethod:(NSString *)httpMethod{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:httpMethod];
    receivedData = [NSMutableData alloc];
    NSURLConnection *connection = [self newAsynchronousRequest:request];
    [connection start];
}

- (void)connection: (NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection{
    [delegate fetchingDataSucceeded:receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate fetchingDataFailed:error];
}


@end
