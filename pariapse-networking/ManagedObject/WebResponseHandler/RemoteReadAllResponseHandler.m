//
//  RemoteReadAllResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteReadAllResponseHandler.h"
#import "RemoteEntityWebUpdater.h"
#import "RemoteEntityFactory.h"

@implementation RemoteReadAllResponseHandler

- (RemoteEntityManager*) entityManager{
	return [RemoteEntityFactory getEntityManagerForEntityNamed: self.remoteEntityName andContext: nil];
}

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi{
	NSObject* webReturned = [WebRequest parseJSON:datas];
	NSArray* arr = (NSArray*)([webReturned isKindOfClass:[NSArray class]]?webReturned: [NSArray arrayWithObject:webReturned]);
	[[[self entityManager] webUpdater] updateEntriesOnWebResult:arr withLocalResults: self.localResults];
	
}

- (void)onError:(NSUInteger)errorCode withURLResponse:(NSHTTPURLResponse *)httpError withWRPI: (WebRequestPoolItem*)wrpi{
	if(errorCode >= 500 || errorCode == 404){
		[wrpi wontEnd];
	}
	[[self entityManager] remoteEntitiesWontBeLoadedMoreThan: self.localResults becauseOfErrorNumber: errorCode];
}

- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{
	[[self entityManager] remoteEntitiesOfflineLoaded: self.localResults];
}

@end
