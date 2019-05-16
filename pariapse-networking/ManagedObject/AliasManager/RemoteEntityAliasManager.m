//
//  RemoteEntityAliasManager.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 21/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityAliasManager.h"
#import "RemoteEntityConfigManager.h"

@implementation RemoteEntityAliasManager

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityAliasManager* attr = [super withManager:manager];
	[manager setAliasManager:attr];
	return attr;
}

- (NSString*)getPropertyNameFromAlias:(NSString*)alias{
	NSDictionary* config = [self.manager.configManager getConfigFromName:@"Aliases"];
	return [config objectForKey:alias];
}

@end
