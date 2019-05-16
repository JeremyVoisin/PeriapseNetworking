//
//  NetworkStateObserver.m
//
//  Created by Jérémy Voisin on 31/03/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "NetworkStateObserver.h"
#import "NetworkStateHelper.h"
#import "Reachability.h"

@implementation NetworkStateObserver

static Reachability* reachability;
static NetworkStateObserver* defaultNetworkObserver = nil;

@synthesize isInformerStarted;

+(NetworkStateObserver*)defaultNetworkStateObserver{
	return (defaultNetworkObserver = ((defaultNetworkObserver == nil)?[self networkChangeObserver]:defaultNetworkObserver));
}

+(NetworkStateObserver*)networkChangeObserver{
	NetworkStateObserver* this = [[NetworkStateObserver alloc]init];
	this.isInformerStarted = NO;
	this.networkChangesSuscribers = [NSMutableSet set];
	[this startObservation];
	return this;
}

-(void)startObservation{
	if(!isInformerStarted){
		isInformerStarted = YES;
		[self startNetworkReachabilityListener];
	}
}

-(void)startNetworkReachabilityListener{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyObservers:) name:kReachabilityChangedNotification object:nil];
	reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
}

-(void)notifyObservers:(NSNotification*)notification{
	Reachability* reachability = notification.object;
	NetworkState state =
		(reachability.currentReachabilityStatus == NotReachable) ?
			DOWN :
		([NetworkStateHelper cellularConnected]?
			CELLULAR :
		(([NetworkStateHelper wiFiConnected])?
			WIFI :
			DOWN));
	for(id<NetworkStateSubscriber> object in _networkChangesSuscribers){
		[object networkDidToggleToState:state];
	}
}

- (void) addNetworkChangesSuscribers:(id<NetworkStateSubscriber>)object{
	[_networkChangesSuscribers addObject:object];
}

- (void) removeNetworkChangesSuscribersAtIndexes:(id<NetworkStateSubscriber>)object{
	[_networkChangesSuscribers removeObject:object];
}

@end
