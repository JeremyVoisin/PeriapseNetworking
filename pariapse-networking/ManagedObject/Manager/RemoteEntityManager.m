//
//  RemoteEntityManager.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityManager.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityURLBuilder.h"
#import "RemoteEntityUpdater.h"
#import "RemoteEntityFinder.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityWebUpdater.h"
#import "RemoteEntityAliasManager.h"

@interface RemoteEntityManager()

@end

@implementation RemoteEntityManager

@synthesize listeners;

-(NSSet*)getListeners{
	return [NSSet setWithSet:listeners];
}

-(void)remoteEntityLoaded:(RemoteEntity*)entity{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntityLoaded:)])
			[listener remoteEntityLoaded:entity];
	}
}

-(void)remoteEntityCreated:(RemoteEntity*)entity{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntityCreated:)])
			[listener remoteEntityCreated:entity];
	}
}

-(void)remoteEntityUpdated:(RemoteEntity*)entity{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntityUpdated:)])
			[listener remoteEntityUpdated:entity];
	}
}

-(void)remoteEntityDeleted:(RemoteEntity*)entity{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntityDeleted:)])
			[listener remoteEntityDeleted:entity];
	}
}

-(void)remoteEntitiesFinishedLoading:(NSArray*)entities{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntitiesFinishedLoading:)])
			[listener remoteEntitiesFinishedLoading: entities];
	}
}

- (void)remoteEntitiesOfflineLoaded:(NSArray*)entities{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntitiesOfflineLoaded:)])
			[listener remoteEntitiesOfflineLoaded: entities];
	}
}

- (void)remoteEntityOnError:(RemoteEntity*)entity withString:(NSString*) error andErrorCode:(NSInteger)errorCode{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntityOnError:withErrorString:andErrorCode:)])
			[listener remoteEntityOnError: entity withErrorString: error andErrorCode:errorCode];
	}
}

- (void)remoteEntitiesWontBeLoadedMoreThan:(NSArray*)entities becauseOfErrorNumber:(NSUInteger)error{
	for(id<RemoteEntityDelegate> listener in [self getListeners]){
		if(listener != nil && [listener respondsToSelector:@selector(remoteEntitiesWontBeLoadedMoreThan:becauseOfErrorNumber:)])
			[listener remoteEntitiesWontBeLoadedMoreThan: entities becauseOfErrorNumber:error];
	}
}

- (void) addWebRequestProperty:(WebRequestURLProperty*)property{
	[_urlProperties addObject:property];
}

- (NSArray*) getWebRequestProperties{
	return _urlProperties;
}

#pragma listening

- (void) removeListener: (id<RemoteEntityDelegate>) delegate{
	[listeners removeObject: delegate];
}

- (void)addListener:(id<RemoteEntityDelegate>)newDelegate{
	[listeners addObject: newDelegate];
}

@end
