//
//  RemoteUpdateResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteUpdateResponseHandler.h"

@implementation RemoteUpdateResponseHandler

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi;{
	RemoteEntity* entity = self.entity;
	[entity unsetConsistencyRulesIn: [wrpi consistencyRules]];
	[[entity getManager] remoteEntityUpdated:entity];
	
}

- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = self.entity;
	[[entity getManager] remoteEntityUpdated:entity];
}


@end
