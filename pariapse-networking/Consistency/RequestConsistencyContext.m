//
//  RequestConsistencyContext.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 19/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RequestConsistencyContext.h"

@implementation RequestConsistencyContext

- (id) init{
	self = [super init];
	self.cont = [NSMutableDictionary dictionary];
	return self;
}

- (id) getObjectForKey: (NSString*) key{
	return [[self.cont allKeys]containsObject:key]?[self.cont objectForKey:key]:nil;
}

- (void) setObject:(NSObject*) object ForKey: (NSString*) key{
	if(object != nil && key != nil)
		[self.cont setObject:object forKey:key];
}

-(id)copyWithZone:(NSZone *)zone{
	typeof(self) another = [[self.class alloc] init];
	return another;
}

#pragma NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.cont = [decoder decodeObjectForKey:@"consistencyContext"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if([[self.cont allKeys]containsObject:@"entity"])[self.cont removeObjectForKey:@"entity"];
	[encoder encodeObject:self.cont forKey:@"consistencyContext"];
}

@end
