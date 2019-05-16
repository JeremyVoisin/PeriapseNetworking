//
//  StandardDeleteCommand.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardDeleteCommand.h"

@implementation StandardDeleteCommand

+(DeleteCommand*)deleteCommandWithURL:(NSString*)whereToSend{
	WebRequestFactory* requestFactory = [[NetworkingFactory defaultNetworkingFactory]getWebRequestFactory];
	DeleteCommand *entity = [[self alloc]init];
	entity.webRequest	= [requestFactory deleteRequestWithURL:whereToSend];
	entity.priority		= 3;
	return entity;
}

-(void) executeWithOnSuccess:(void (^)(NSData *))onSuccess onError:(void (^)(NSUInteger, NSHTTPURLResponse*))onError{
	[self.webRequest sendRequestWithEndingBlock:^{
		if([self.webRequest response]==nil && onError != nil){
			onError(self.webRequest.httpStatus, self.webRequest.httpURLResponse);
		}
		else if(onSuccess != nil){
			onSuccess([self.webRequest response]);
		}
	}];
}

@end
