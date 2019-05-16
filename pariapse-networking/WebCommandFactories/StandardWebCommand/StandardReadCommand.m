//
//  StandardReadCommand.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardReadCommand.h"

@implementation StandardReadCommand

+(ReadCommand*)readCommandWithURL:(NSString*)whereToSend{
	WebRequestFactory* requestFactory = [[NetworkingFactory defaultNetworkingFactory]getWebRequestFactory];
	ReadCommand *entity = [[self alloc]init];
	[entity setWebRequest:[requestFactory readRequestWithURL:whereToSend]];
	[entity setPriority: 4];
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
