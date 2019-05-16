//
//  RemoteEntityWebUpdater.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 12/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityWebUpdater.h"
#import "WebRequestPoolItemFactory.h"
#import "RemoteEntityURLBuilder.h"
#import "RemoteEntityFinder.h"
#import "RemoteEntityUpdater.h"
#import "RemoteReadAllResponseHandler.h"

@implementation RemoteEntityWebUpdater

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityWebUpdater* webu = [super withManager:manager];
	[manager setWebUpdater:webu];
	return webu;
}

- (void) getAllEntitiesWithEndingBlock:(void(^)(NSArray*)) endingBlock withParams:(NSDictionary*) params{
	NSArray* foundEntitiesForParams = [[self.manager finder] getOfflineEntitiesWithParams: params];
	if(endingBlock != nil)endingBlock(foundEntitiesForParams);
	RemoteReadAllResponseHandler* responseHandler = [RemoteReadAllResponseHandler new];
	[responseHandler setLocalResults:foundEntitiesForParams];
	[responseHandler setRemoteEntityName:self.manager.managersAttachedEntityName];
	WebRequestPoolItem *wrpi = [[WebRequestPoolItemFactory webRequestPoolItemFactory]readFromURL:[[self.manager urlBuilder] urlForAllRemoteEntitiesWithParams:params] withResponseHandler:responseHandler];
	[self initializeWebRequestPropertiesForWRPI:wrpi];
	[wrpi setIdentifier:[self identifierForWRPI: wrpi]];
	[wrpi setReady];
}

- (void) updateEntriesOnWebResult: (NSArray*) results withLocalResults:(NSArray*)localResults{
	NSArray* updatedEntities = [[[self manager] webUpdater] updateAllLocalEntriesWithWebResult: results];
	if(localResults != nil){
		for(RemoteEntity* entity in localResults){
			if(![updatedEntities containsObject:entity] && [entity allowAutoDeleteOnGlobalUpdate]){
				[entity shouldNotSendUpdate];
				[entity autoDelete];
			}
		}
	}
	[[self manager] remoteEntitiesFinishedLoading:updatedEntities];
}


- (NSArray*) getWebRequestProperties{
	return [self.manager getWebRequestProperties];
}

- (void) initializeWebRequestPropertiesForWRPI:(WebRequestPoolItem*)wrpi{
	for(__strong WebRequestURLProperty* c in [self getWebRequestProperties]){
		[wrpi setRequestProperty:c];
	}
}

- (NSArray*) updateAllLocalEntriesWithWebResult: (NSArray*) webResult{
	NSArray* results = [[self.manager updater] updateAllLocalEntriesCorrespondingToDatas:webResult];
	[self.contexte save:nil];
	return results;
}

- (NSString*) identifierForWRPI: (WebRequestPoolItem*) wrpi{
	return self.manager.managersAttachedEntityName;
}

@end
