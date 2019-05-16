//
//  WebRequestFactory.m
//
//  Created by Jérémy Voisin on 19/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "WebRequestFactory.h"

@implementation WebRequestFactory

-(ReadRequest*)readRequestWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
}

-(UpdateRequest*)updateRequestWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
}

-(DeleteRequest*)deleteRequestWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
}

-(PostRequest*)postRequestWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
}

@end
