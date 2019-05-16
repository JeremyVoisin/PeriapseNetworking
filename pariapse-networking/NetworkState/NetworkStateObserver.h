//
//  NetworkStateObserver.h
//
//  Created by Jérémy Voisin on 31/03/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkStateSubscriber.h"

@interface NetworkStateObserver : NSObject

@property BOOL isInformerStarted;
@property NSMutableSet* networkChangesSuscribers;

+(NetworkStateObserver*)defaultNetworkStateObserver;
+(NetworkStateObserver*)networkChangeObserver;

- (void) addNetworkChangesSuscribers:(id<NetworkStateSubscriber>)object;
- (void) removeNetworkChangesSuscribersAtIndexes:(id<NetworkStateSubscriber>)object;
@end
