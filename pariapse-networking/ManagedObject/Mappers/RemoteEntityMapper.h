//
//  RemoteEntityMapper.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityManageable.h"
#import "RemoteEntity.h"

#ifndef REMOTEENTITYMAPPER_H
#define REMOTEENTITYMAPPER_H

@interface RemoteEntityMapper : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;
- (NSDictionary*) getDictionaryFromRemoteEntity:(RemoteEntity*) entity
						 comingFromAccumulator:(NSMutableSet*)accumulator
									notSendable:(NSSet*)notSendable;
- (void) setRemoteEntityAttributes:(RemoteEntity*) entity fromDictionary:(NSDictionary*) dict;
- (BOOL) areProperties:(NSDictionary*) properties correspondingToRemoteEntitysAttribute:(RemoteEntity*) remoteEntity;
- (BOOL) isPropertyExisting: (NSString*)propertyName;
- (RemoteEntityManager*) mapEntityManagerForPath:(NSString*) path;
- (NSObject*) mapAttributeForPath:(NSString*)path inEntity:(RemoteEntity*)entity;
- (RemoteEntity*) mapUnaryRelationshipForPath:(NSString*)path inEntity: (RemoteEntity*)entity;
- (NSArray*) mapNaryRelationshipForPath:(NSString*)path inEntity: (RemoteEntity*)entity;
- (NSObject*) mapObjectForPath:(NSString *)path inEntity:(RemoteEntity *)entity;
- (NSString*) toPermanentIdentifier: (RemoteEntity*) entity;

@end

#endif
