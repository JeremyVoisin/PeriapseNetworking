//
//  RemoteDeleteResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteDeleteResponseHandler.h"

@implementation RemoteDeleteResponseHandler

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = self.entity;
	[entity unsetConsistencyRulesIn: [wrpi consistencyRules]];
	[[entity getManager] remoteEntityDeleted:entity];
	
}

- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = self.entity;
	[[entity getManager] remoteEntityDeleted:entity];
}

@end
