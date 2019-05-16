//
//  StandardWebRequestFactory.m
//
//  Created by Jérémy Voisin on 19/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardWebRequestFactory.h"
#import "StandardReadRequest.h"
#import "StandardPostRequest.h"
#import "StandardUpdateRequest.h"
#import "StandardDeleteRequest.h"

@implementation StandardWebRequestFactory

-(ReadRequest*)readRequestWithURL:(NSString*)url{
	return [[StandardReadRequest alloc]initWithURL:url];
}

-(UpdateRequest*)updateRequestWithURL:(NSString*)url{
	return [[StandardUpdateRequest alloc]initWithURL:url];
}

-(DeleteRequest*)deleteRequestWithURL:(NSString*)url{
	return [[StandardDeleteRequest alloc]initWithURL:url];
}

-(PostRequest*)postRequestWithURL:(NSString*)url{
	return [[StandardPostRequest alloc]initWithURL:url];
}

@end
