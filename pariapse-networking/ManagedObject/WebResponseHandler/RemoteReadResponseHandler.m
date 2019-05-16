//
//  RemoteReadResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteReadResponseHandler.h"
#import "WebRequest.h"
#import "RemoteEntity.h"

@implementation RemoteReadResponseHandler

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = [self entity];
	[entity shouldNotSendUpdate];
	[entity setWithDictionary:(NSDictionary*)[WebRequest parseJSON:datas]];
	[entity.managedObjectContext save:nil];
	[entity unsetConsistencyRulesIn: [wrpi consistencyRules]];
	[entity setTransmissionState: RemoteEntityTransmissionStateUpToDate];
	[[entity getManager] remoteEntityLoaded:entity];

}

- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{
	RemoteEntity* entity = [self entity];
	[[entity getManager] remoteEntityLoaded:entity];
}


@end
