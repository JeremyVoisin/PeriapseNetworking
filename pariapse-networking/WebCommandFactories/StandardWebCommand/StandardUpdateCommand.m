//
//  StandardUpdateCommand.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardUpdateCommand.h"

@implementation StandardUpdateCommand

+(UpdateCommand*)updateCommandWithURL:(NSString*)whereToSend andDatasToSend:(NSArray*)datas{
	WebRequestFactory* requestFactory = [[NetworkingFactory defaultNetworkingFactory]getWebRequestFactory];
	UpdateCommand *entity = [[self alloc]init];
	entity.toSend		= datas;
	entity.webRequest	= [requestFactory updateRequestWithURL:whereToSend];
	entity.priority		= 2;
	return entity;
}

-(void) executeWithOnSuccess:(void (^)(NSData *))onSuccess onError:(void (^)(NSUInteger, NSHTTPURLResponse*))onError{
	[self.webRequest setToSend:[WebRequest encodeInJSON:[self toSend]]];
	[self.webRequest sendRequestWithEndingBlock:^(void) {
		if([self.webRequest response]==nil && onError != nil){
			onError(self.webRequest.httpStatus, self.webRequest.httpURLResponse);
		}
		else if(onSuccess != nil){
			onSuccess([self.webRequest response]);
		}
	}];
}

@end
