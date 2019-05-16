//
//  NetConfig.m
//
//  Created by Jérémy Voisin on 04/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "NetConfig.h"

@implementation NetConfig

static NSDictionary* config = nil;

+ (NSDictionary*)getConfig{
	return (config = (config == nil) ? [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetConfig" ofType:@"plist"]] : config);
}

+ (NSObject*)getConfigFor:(NSString*)configName{
	return [(config = (config == nil) ? [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetConfig" ofType:@"plist"]] : config) objectForKey:configName];
}

+ (NSString*) getSerializerParamName{
	return @"WebRequestSerializer";
}

+ (NSString*) defaultParserName{
	return @"JSONWebRequestSerializer";
}

+ (Class<WebRequestSerializerProtocol>) getWebRequestSerializer{
	NSString* serializerClassName = (NSString*)[self getConfigFor:[self getSerializerParamName]];
	return NSClassFromString((serializerClassName == nil) ? [self defaultParserName]: serializerClassName);
}

@end
