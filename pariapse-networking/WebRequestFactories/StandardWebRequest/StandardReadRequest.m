//
//  StandardReadRequest.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardReadRequest.h"

@implementation StandardReadRequest

-(void) sendRequestWithEndingBlock:(void(^ _Nonnull)(void))completion{
	if(self.isAsync)[self asynchronousRequestWithCompletionHandler:completion];
	else [self getDataWithCompletionHandler:completion];
}

-(void) getDataWithCompletionHandler:(void(^ _Nonnull)(void))completion{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:self.url]];
	[self setRequestProperty:request];
	[[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:Nil] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable retour, NSError * _Nullable error) {
		[self handleResponse:completion withDatas:data andTheHTTPResponse:retour];
	}] resume];
}

- (void) asynchronousRequestWithCompletionHandler:(void(^ _Nonnull)(void))completion{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
	[request setHTTPMethod:@"GET"];
	[[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable retour, NSError * _Nullable error) {
		[self handleResponse:completion withDatas:data andTheHTTPResponse:retour];
	}] resume];
}

@end
