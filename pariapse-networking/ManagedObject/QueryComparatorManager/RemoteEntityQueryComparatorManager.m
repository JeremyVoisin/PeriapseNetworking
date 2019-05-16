//
//  RemoteEntityQueryComparatorManager.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 26/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityQueryComparatorManager.h"
#import "RemoteEntityConfigManager.h"

@implementation RemoteEntityQueryComparatorManager

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityQueryComparatorManager* attr = [super withManager:manager];
	[manager setQueryComparatorManager:attr];
	return attr;
}

- (NSString*)getQueryComparatorFromPropertyName:(NSString*)name{
	NSDictionary* config = [self.manager.configManager getConfigFromName:@"QueryComparator"];
	return ([[config allKeys] containsObject:name]?[config objectForKey:name]:@"==");
}

@end
