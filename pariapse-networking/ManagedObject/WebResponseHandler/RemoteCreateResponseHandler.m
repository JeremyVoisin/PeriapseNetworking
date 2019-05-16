//
//  RemoteCreateResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteCreateResponseHandler.h"

@implementation RemoteCreateResponseHandler

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = [self entity];
	[entity unsetConsistencyRulesIn: [wrpi consistencyRules]];
	[[entity getManager] remoteEntityCreated:entity];
	
}

- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = [self entity];
	[[entity getManager] remoteEntityCreated:entity];
}


@end
