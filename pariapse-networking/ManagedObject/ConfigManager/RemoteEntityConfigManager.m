//
//  RemoteEntityConfigManager.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 27/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityConfigManager.h"

@interface RemoteEntityConfigManager()
@property NSMutableDictionary* configDictionary;
@end


@implementation RemoteEntityConfigManager

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityConfigManager* attr = [super withManager:manager];
	[manager setConfigManager:attr];
	return attr;
}

- (NSDictionary*)getConfigFromName:(NSString*)name{
	if(_configDictionary==nil)[self loadConfig];
	return ([[_configDictionary allKeys] containsObject:name]?[_configDictionary objectForKey:name]:[NSDictionary dictionary]);
}

- (NSDictionary*)loadConfig{
	return (_configDictionary = (_configDictionary == nil) ? [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Config",self.manager.managersAttachedEntityName] ofType:@"plist"]] : _configDictionary);
}


@end
