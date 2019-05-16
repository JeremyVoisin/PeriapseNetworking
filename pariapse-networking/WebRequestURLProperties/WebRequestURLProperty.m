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
	if(self.property != nil)[self.property setProperty:aProperty];
	else if(aProperty != nil)self.property = aProperty;
}

- (void)setProperties:(NSSet *)properties{
	for(id<WebRequestURLPropertyProtocol> aProperty in properties){
		if(self.property != nil)[self.property setProperty:aProperty];
		else self.property = aProperty;
	}
}

- (void)setRequestProperty:(NSMutableURLRequest*)request{
	if(self.property != nil)[self.property setRequestProperty:request];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.property = [decoder decodeObjectForKey:@"property"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:property forKey:@"property"];
}

@end
