//
//  NetCommunicator.h
//  iOS-login-boilerplate
//
//  Created by michael whitehead on 9/24/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetCommunicator : NSObject <NSURLConnectionDelegate>{

   @private NSMutableData *receivedData;
}

@property (nonatomic, retain) id delegate;

- (void)fetchDataFromURL:(NSURL *)url httpMethod:(NSString *)httpMethod;
- (NSURLConnection *)newAsynchronousRequest:(NSURLRequest *)request;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
