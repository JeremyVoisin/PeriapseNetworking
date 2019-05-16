//
//  WebRequestPoolSaver.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 12/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "WebRequestPoolSaver.h"
#import "WebRequestPool.h"

@implementation WebRequestPoolSaver

static WebRequestPoolSaver* defaultSaver = nil;

+ (WebRequestPoolSaver*) defaultSaver{
	if(defaultSaver == nil)defaultSaver = [[WebRequestPoolSaver alloc]init];
	return defaultSaver;
}

- (id<NSCoding>)whatsToSave:(WebRequestPool*)pool{
	return pool.scenariosManager;
}

+ (NSString*) localName{
	return @"webRequestPool";
}

- (void) save: (WebRequestPool*)pool{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self whatsToSave:pool]];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:[self.class localName]];

}

@end
