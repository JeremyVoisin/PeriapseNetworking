//
//  StandardPostRequest.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardPostRequest.h"

@implementation StandardPostRequest

-(void) sendRequestWithEndingBlock:(void(^ _Nonnull)(void))completion{
	[self postDataWithBody:self.toSend andCompletionHandler:completion];
}

/**
 Requete POST vers le serveur pour l'envoie de données
 */
- (void) postDataWithBody:(NSData * _Nonnull)body andCompletionHandler:(void(^ _Nonnull)(void))completion{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	[request setValue: @"application/json, text/plain, */*" forHTTPHeaderField: @"Accept"];
	[request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
	[request setURL:[NSURL URLWithString:self.url]];
	[self setRequestProperty:request];
	
	[[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:Nil] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable retour, NSError * _Nullable error) {
		[self handleResponse:completion withDatas:data andTheHTTPResponse:retour];
	}] resume];
}

@end
