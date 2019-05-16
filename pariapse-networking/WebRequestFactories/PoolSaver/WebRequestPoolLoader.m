//
//  WebRequestPoolLoader.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 12/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "WebRequestPoolLoader.h"
#import "WebRequestPool.h"

@implementation WebRequestPoolLoader

static WebRequestPoolLoader* defaultLoader = nil;

+ (WebRequestPoolLoader*) defaultLoader{
	if(defaultLoader == nil)defaultLoader = [[WebRequestPoolLoader alloc]init];
	return defaultLoader;
}

- (void)restoreToPool:(WebRequestPool*)pool withUnarchivedData:(id<NSCoding>)datas{
	if(datas != nil)pool.scenariosManager = (DataScenariosManager*)datas;
}

+ (NSString*) localName{
	return @"webRequestPool";
}

- (void) load: (WebRequestPool*)pool{
	NSData *datas = [[NSUserDefaults standardUserDefaults] objectForKey:[self.class localName]];
	[self restoreToPool:pool withUnarchivedData:[NSKeyedUnarchiver unarchiveObjectWithData:datas]];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:[self.class localName]];
}

@end
