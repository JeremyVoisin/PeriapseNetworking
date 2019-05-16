//
//  StandardDeleteRequest.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardDeleteRequest.h"

@implementation StandardDeleteRequest

-(void)sendRequestWithEndingBlock:(void (^)(void))completion{
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"DELETE"];
	[request setValue: @"application/json, text/plain, */*" forHTTPHeaderField: @"Accept"];
	[request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
	[request setURL:[NSURL URLWithString:self.url]];
	[self setRequestProperty:request];
	
	[[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:Nil] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable retour, NSError * _Nullable error) {
		[self handleResponse:completion withDatas:data andTheHTTPResponse:retour];
	}] resume];
}

@end
