//
//  WebRequestPool.m
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "WebRequestPool.h"

@implementation WebRequestPool

@synthesize scenariosManager;
@synthesize isCellularAuthorized;

static WebRequestPool* defaultPool = nil;
static NSString* kPoolItemActivityOnNotification = @"kPoolItemActivityOnNotification";
static NSString* kPoolItemActivityOffNotification = @"kPoolItemActivityOffNotification";
static NSString* kAuthenticationSuccessfulNotification = @"kAuthenticationSuccessfulNotification";
static NSString* kAuthenticationNeededNotification = @"kAuthenticationNeededNotification";

#pragma Constructors

+ (WebRequestPool*) defaultWebRequestPool{
	return (defaultPool = (defaultPool == nil?[WebRequestPool webRequestPool]:defaultPool));
}

+ (WebRequestPool*) webRequestPool{
	WebRequestPool* this = [[WebRequestPool alloc]init];
	this.scenariosManager = [DataScenariosManager scenariosManager];
	this.runningRequest = [NSMutableSet set];
	[this initRequestPool];
	return this;
}

- (void) initRequestPool{
	self.currentNetworkType = [self.class detectNetworkType];
	self.isCellularAuthorized = YES;
	[self waitForAuthenticationNotification];
	[[NetworkStateObserver defaultNetworkStateObserver] addNetworkChangesSuscribers:self];
}

+ (NetworkState) detectNetworkType{
	return [NetworkStateHelper networkType];
}

- (void) setIsCellularAuthorized:(BOOL)cellularAuthorized{
	isCellularAuthorized = cellularAuthorized;
	if(cellularAuthorized)[self executePendingAndRunningRequests];
}

- (BOOL) isCellularAuthorized{
	return isCellularAuthorized;
}

#pragma NetworkStateSubscriber

- (void)networkDidToggleToState:(NetworkState)networkState{
	int previousNetworkState = _currentNetworkType;
	_currentNetworkType = networkState;
	[[self runningRequest] removeAllObjects];
	if(![self isNetworkDown] && _currentNetworkType != previousNetworkState)
		[self executePendingAndRunningRequests];
	else{
		[self notify];
	}
}

#pragma After networking loss

- (void)executePendingRequests{
	NSArray* rootEntities = [scenariosManager getRootEntities];
	for(__strong WebRequestPoolItem* item in rootEntities)
		[self executePoolItem:item];
}
	
- (void) executePendingAndRunningRequests{
	NSMutableSet* set = [NSMutableSet set];
	[set addObjectsFromArray: [[self runningRequest] allObjects]];
	[set addObjectsFromArray: [scenariosManager getRootEntities]];
	for(__strong WebRequestPoolItem* wrpi in set){
		if([[self runningRequest]containsObject:wrpi])
		   [wrpi execute];
		else
		   [self executePoolItem: wrpi];
	}
}

#pragma WebRequestPoolItemDelegate

- (BOOL) isNetworkDown{
	return (_currentNetworkType == DOWN || (_currentNetworkType == CELLULAR && !isCellularAuthorized));
}

- (void) resetPool{
	[[self scenariosManager] resetScenarios];
	[[self runningRequest] removeAllObjects];
}

- (void)webRequestPoolItemIsReady:(WebRequestPoolItem*)poolItem{
	if([self isNetworkDown]){
		[scenariosManager addEntity:poolItem];
		[self webRequestPoolItemReactToNetworkDown:poolItem];
	}else{
		if(([poolItem identifier] != nil && [scenariosManager getRootEntitiesNumberForKey:[poolItem identifier]] == 0) || [poolItem identifier] == nil){
			[scenariosManager addEntity:poolItem];
			[self executePoolItem: poolItem];
		}else{
			[scenariosManager addEntity:poolItem];
		}
	}
}

- (void)webRequestPoolItemReactToNetworkDown:(WebRequestPoolItem*)poolItem{
	[poolItem.responseHandler onOfflineWithWRPI: poolItem];
}


- (void)webRequestPoolItemSucceeded:(WebRequestPoolItem*)poolItem{
#ifdef VERBOSE_MODE
	NSLog(@"Call to %@ succeeded",poolItem.command.webRequest.url);
#endif
	[self poolItemsEnding:poolItem];
}


- (void)webRequestPoolItemWillNotEnd:(WebRequestPoolItem*)poolItem{
#ifdef VERBOSE_MODE
	NSLog(@"Call to %@ will not end",poolItem.command.webRequest.url);
#endif
	[self poolItemsEnding:poolItem];
}

-(void)webRequestPoolItem:(WebRequestPoolItem*)poolItem needsPoolActionOnWebRequestErrorWithCompletion:(void(^)(NSData*))completion{
	completion(nil);
}

- (void)poolItemsEnding:(WebRequestPoolItem*)poolItem{
	[self.runningRequest removeObject: poolItem];
	[self notify];
	if([poolItem identifier] != nil && [scenariosManager getRootEntitiesNumberForKey:[poolItem identifier]] == 1){
		[scenariosManager removeEntity:poolItem];
		NSArray* nextEntities = [scenariosManager getEntitiesForKey:[poolItem identifier]];
		for(__strong WebRequestPoolItem* item in nextEntities){
			[self executePoolItem:item];
		}
	}else{
		[scenariosManager removeEntity:poolItem];
	}
}

- (void) executePoolItem: (WebRequestPoolItem*)item{
	if(![self.runningRequest containsObject:item]){
		[self.runningRequest addObject:item];
		[self notify];
		[item setDelegate:self];
		[item execute];
	}
}

- (void) authenticationSuccessfulNotification{
	[self executePendingAndRunningRequests];
	[self notify];
}

- (void) waitForAuthentication{
	[self notifyPoolRequestActivityEnding];
}

- (void) notify{
	if([self.runningRequest count] == 0 || [self isNetworkDown])
		[self notifyPoolRequestActivityEnding];
	else [self notifyPoolRequestActivity];
}
	
- (BOOL) existsIdentifiedRequest:(NSString*)identifier{
	return [self.scenariosManager getRootEntitiesNumberForKey: identifier] > 0;
}

#pragma ActivityNotification

- (void) notifyPoolRequestActivity{
	[[NSNotificationCenter defaultCenter] postNotificationName: kPoolItemActivityOnNotification object: nil];
}

- (void) notifyPoolRequestActivityEnding{
	[[NSNotificationCenter defaultCenter] postNotificationName: kPoolItemActivityOffNotification object: nil];
}

- (void) notifyAuthenticationSuccessful{
	[[NSNotificationCenter defaultCenter] postNotificationName: kAuthenticationSuccessfulNotification object: nil];
}

- (void) addObserver:(id<WebRequestPoolActivityListener>)observer{
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(webRequestPoolActivityStarted) name:kPoolItemActivityOnNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(webRequestPoolActivityEnded) name:kPoolItemActivityOffNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(webRequestPoolRequiresAuthentication) name:kAuthenticationNeededNotification object:nil];
	[self notify];
}

-(void) waitForAuthenticationNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationSuccessfulNotification) name:kAuthenticationSuccessfulNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitForAuthentication) name:kAuthenticationNeededNotification object:nil];
}
 
#pragma NSCoding

- (void) savePoolWithPoolSaver:(WebRequestPoolSaver*)saver{
	if(saver == nil)saver = [WebRequestPoolSaver defaultSaver];
	[saver save:self];
}

- (void) restorePoolWithPoolLoader:(WebRequestPoolLoader*)loader{
	if(loader == nil)loader = [WebRequestPoolLoader defaultLoader];
	[loader load:self];
}

@end
