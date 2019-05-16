//
//  RemoteEntityURLBuilder.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 06/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityURLBuilder.h"
#import "RemoteEntityAttributesTransformer.h"

@interface RemoteEntityURLBuilder()

@end

@implementation RemoteEntityURLBuilder

NSDictionary* remoteEntityURLs = nil;

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityURLBuilder* urlb = [super withManager:manager];
	[manager setUrlBuilder:urlb];
	return urlb;
}

+ (NSDictionary*) loadPropertiesFromFile:(NSString*) fileName{
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
}

- (NSString*) baseURLForEntity{
	return [self.class baseURLForEntityNamed:self.manager.managersAttachedEntityName];
}

- (NSString*) urlForRemoteEntitiesWithParams: (NSDictionary*) params{
	return [NSString stringWithFormat:@"%@%@",[self baseURLForEntity],[self mapAttributesForURL: params]];
}

+ (NSString*) baseURLForEntityNamed: (NSString*) name{
	if(remoteEntityURLs == nil)remoteEntityURLs = [self loadPropertiesFromFile:@"URLConfig"];
	return [remoteEntityURLs objectForKey:name];
}

- (NSString*) urlForAllRemoteEntities{
	return [self urlForRemoteEntitiesWithParams:@{}];
}

- (NSString*) urlForAllRemoteEntitiesWithParams:(NSDictionary*)params{
	return [self urlForRemoteEntitiesWithParams:params];
}

- (NSString*) mapAttributesForURL: (NSDictionary*)params{
	return [self.manager.attributesTransformer toURLParamsFromDatas:params];
}

- (NSString*) urlForRemoteEntity:(RemoteEntity*)remoteEntity{
	NSMutableString* toReturn = [NSMutableString string];
	[toReturn appendString:[NSString stringWithFormat:@"%@/",[self baseURLForEntity]]];
	[toReturn appendString:[NSString stringWithFormat:@"%@",[remoteEntity getIndexValue]]];
	return toReturn;
}

- (NSString*) urlForRemoteEntity:(RemoteEntity*)remoteEntity withParameters: (NSDictionary*) parameters{
	return [NSString stringWithFormat:@"%@%@",[self urlForRemoteEntity:remoteEntity],[self.manager.attributesTransformer toURLParamsFromDatas:parameters]];
}

- (NSString*) getURLParamsFormat{
	return @"%@%@=%@";
}

- (NSString*) getURLFirstPassMarker{
	return @"?";
}

- (NSString*) getURLNotFirstPassMarker{
	return @"&";
}

@end
