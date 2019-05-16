//
//  WebRequestPool.h
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestPoolItemFactory.h"
#import "DataScenariosManager.h"
#import "NetworkingFactory.h"
#import "WebRequestPoolSaver.h"
#import "WebRequestPoolLoader.h"
#import "WebRequestPoolActivityListener.h"

@interface WebRequestPool : NSObject<NetworkStateSubscriber, WebRequestPoolItemDelegate>

@property int currentNetworkType;
@property(atomic) NSMutableSet* runningRequest;
@property DataScenariosManager* scenariosManager;
@property (atomic) BOOL isCellularAuthorized;

+ (WebRequestPool*) defaultWebRequestPool;
- (void) savePoolWithPoolSaver:(WebRequestPoolSaver*)saver;
- (void) restorePoolWithPoolLoader:(WebRequestPoolLoader*)loader;
- (void)executePendingRequests;
- (void) addObserver:(id<WebRequestPoolActivityListener>)observer;
- (void) notifyAuthenticationSuccessful;
- (void) resetPool;
- (BOOL) existsIdentifiedRequest:(NSString*)identifier;

@end
 
