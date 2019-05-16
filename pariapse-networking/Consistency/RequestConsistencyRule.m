//
//  RequestConsistencyRule.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 19/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RequestConsistencyRule.h"

@implementation RequestConsistencyRule

- (id) init{
	self = [super init];
	self.context = [[RequestConsistencyContext alloc]init];
	return self;
}

- (BOOL) checkConsistencyOfWRPI: (WebRequestPoolItem*)item{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract checkConsistencyOfWRPI: method directly." userInfo:nil];
}

- (void) applyConsistencyToWRPI: (WebRequestPoolItem*)item{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract applyConsistencyToWRPI: method directly." userInfo:nil];
}

-(id)copyWithZone:(NSZone *)zone{
	
	RequestConsistencyRule *another = [[self.class alloc] init];
	another.context = [self.context copyWithZone: zone];
	return another;
}

#pragma NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.context = [decoder decodeObjectForKey:@"contexte"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.context forKey:@"contexte"];
}
@end
