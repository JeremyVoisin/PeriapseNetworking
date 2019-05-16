//
//  StandardPostCommand.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardPostCommand.h"

@implementation StandardPostCommand

+(PostCommand*)postCommandWithURL:(NSString*)whereToSend andDatasToSend:(NSArray*)datas{
	WebRequestFactory* requestFactory = [[NetworkingFactory defaultNetworkingFactory]getWebRequestFactory];
	PostCommand *entity = [[self alloc]init];
	entity.toSend		= datas;
	entity.webRequest	= [requestFactory postRequestWithURL:whereToSend];
	entity.priority		= 1;
	return entity;
}

-(void) executeWithOnSuccess:(void (^)(NSData *))onSuccess onError:(void (^)(NSUInteger, NSHTTPURLResponse*))onError{
	[self.webRequest setToSend:[WebRequest encodeInJSON:[self toSend]]];
	[self.webRequest sendRequestWithEndingBlock:^(void) {
		if(self.webRequest.response == nil && onError != nil){
			onError(self.webRequest.httpStatus, self.webRequest.httpURLResponse);
		}
		else if(onSuccess != nil){
			onSuccess([self.webRequest response]);
		}
	}];
}

@end
