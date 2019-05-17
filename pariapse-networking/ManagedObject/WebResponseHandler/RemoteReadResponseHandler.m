/*!
 * @file RemoteReadResponseHandler.m
 * @framework PeriapseNetworking

 * @author Jérémy Voisin
 * @copyright © 2019 Jérémy Voisin
 * @version 1.0
 */

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
