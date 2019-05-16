//
//  UpdateCommand.m
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "UpdateCommand.h"

@implementation UpdateCommand

@synthesize priority;
@synthesize webRequest;
@synthesize toSend;

- (id)init{
	if ([self class] == [UpdateCommand class]) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException
									   reason:@"Error, attempting to instantiate UpdateCommand directly." userInfo:nil];
	}
	
	self = [super init];
	if (self) {
		// Initialization code here.
	}
	
	return self;
}

+(id)updateCommandWithURL:(NSString*)whereToSend andDatasToSend:(NSObject*)datas{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

-(void) executeWithOnSuccess:(void (^)(NSData *))onSuccess onError:(void (^)(NSUInteger, NSHTTPURLResponse*))httpError{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.priority = (int)[decoder decodeIntegerForKey:@"priority"];
		self.toSend = [decoder decodeObjectForKey:@"toSend"];
		self.webRequest = [decoder decodeObjectForKey:@"webRequest"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:priority forKey:@"priority"];
	[encoder encodeObject:toSend forKey:@"toSend"];
	[encoder encodeObject:webRequest forKey:@"webRequest"];
}

@end
