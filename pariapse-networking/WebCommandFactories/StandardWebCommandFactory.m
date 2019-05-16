//
//  StandardWebCommandFactory.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "StandardWebCommandFactory.h"

@implementation NSObject(WebCommandFactoryAddition)
-(NSObject*) transformeDatasToSendToBeJSONAble{
	return self;
}
@end

@implementation NSData(WebCommandFactoryAddition)
-(NSString*) transformeDatasToSendToBeJSONAble{
	return [self base64EncodedStringWithOptions: 0];
}
@end

@implementation NSArray(WebCommandFactoryAddition)
-(NSArray*) transformeDatasToSendToBeJSONAble{
	NSMutableArray* toReturn = [NSMutableArray array];
	for(NSObject* obj in self){
		[toReturn addObject: [obj transformeDatasToSendToBeJSONAble]];
	}
	return toReturn;
}
@end

@implementation NSSet(WebCommandFactoryAddition)
-(NSSet*) transformeDatasToSendToBeJSONAble{
	NSMutableSet* toReturn = [NSMutableSet set];
	for(NSObject* obj in self){
		[toReturn addObject: [obj transformeDatasToSendToBeJSONAble]];
	}
	return toReturn;
}
@end

@implementation NSDictionary(WebCommandFactoryAddition)
-(NSDictionary*) transformeDatasToSendToBeJSONAble{
	NSMutableDictionary* toReturn = [NSMutableDictionary dictionary];
	for(NSString* key in [self allKeys]){
		[toReturn setObject: [[self objectForKey:key] transformeDatasToSendToBeJSONAble] forKey: key];
	}
	return toReturn;
}
@end

@implementation StandardWebCommandFactory

-(NSObject*) transformeDatasToSendToBeJSONAble:(NSObject*)toSend{
	return [toSend transformeDatasToSendToBeJSONAble];
}

-(ReadCommand*)readCommandWithURL:(NSString*)url{
	return [StandardReadCommand readCommandWithURL:url];
}

-(UpdateCommand*)updateCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend{
	return [StandardUpdateCommand updateCommandWithURL:url andDatasToSend: [self transformeDatasToSendToBeJSONAble: toSend]];
}

-(DeleteCommand*)deleteCommandWithURL:(NSString*)url{
	return [StandardDeleteCommand deleteCommandWithURL:url];
}

-(PostCommand*)postCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend{
	return [StandardPostCommand postCommandWithURL:url andDatasToSend:[self transformeDatasToSendToBeJSONAble: toSend]];
}

@end
