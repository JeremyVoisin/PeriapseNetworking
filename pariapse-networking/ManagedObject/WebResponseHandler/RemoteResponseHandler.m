//
//  RemoteResponseHandler.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "RemoteResponseHandler.h"

@implementation RemoteResponseHandler

@synthesize entity;

- (RemoteEntity *)entity{
	if(entity == nil){
		RemoteEntityManager* manager = [RemoteEntityFactory getEntityManagerForEntityNamed: self.remoteEntityName andContext: nil];
		entity = [manager.finder findWithPermanentIdentifier: self.entityUUID];
	}
	return entity;
}

- (void)setEntity:(RemoteEntity *)ent{
	entity = ent;
	self.entityUUID = [ent toPermanentIdentifier];
	self.remoteEntityName = ent.entity.name;
}

- (void)onSuccess:(NSData *)datas withWRPI: (WebRequestPoolItem*)wrpi{}

- (void)onOfflineWithWRPI: (WebRequestPoolItem*)wrpi{}

- (void) onError:(NSUInteger) errorCode withURLResponse: (NSHTTPURLResponse*) httpError withWRPI: (WebRequestPoolItem*)wrpi;{
	[self.entity handleWRPIError: wrpi errorCode: errorCode];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.entityUUID = [decoder decodeObjectForKey:@"entityUUID"];
		self.remoteEntityName = [decoder decodeObjectForKey:@"remoteEntityName"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.entityUUID forKey:@"entityUUID"];
	[encoder encodeObject:self.remoteEntityName forKey:@"remoteEntityName"];
}


@end
