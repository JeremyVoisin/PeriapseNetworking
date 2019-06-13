//
//  WebRequestURLProperty.m
//
//  Created by Jérémy Voisin on 05/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "WebRequestURLProperty.h"

@implementation WebRequestURLProperty

@synthesize property;

- (void)setProperty:(id<WebRequestURLPropertyProtocol>)aProperty{
	if(property != nil && property != self && aProperty != self)[property setProperty:aProperty];
	else if(aProperty != nil && aProperty != self)property = aProperty;
}

- (void)setProperties:(NSSet *)properties{
	for(id<WebRequestURLPropertyProtocol> aProperty in properties){
		if(property != nil && property != self && aProperty != self)[property setProperty:aProperty];
		else if (aProperty != self && property != self) property = aProperty;
	}
}

- (void)setRequestProperty:(NSMutableURLRequest*)request{
	if(property != nil)[self.property setRequestProperty:request];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		property = [decoder decodeObjectForKey:@"property"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:property forKey:@"property"];
}

@end
