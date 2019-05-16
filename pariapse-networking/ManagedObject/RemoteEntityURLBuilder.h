//
//  RemoteEntityURLBuilder.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 06/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityManageable.h"
#import "RemoteEntity.h"

#ifndef REMOTEENTITYURLBUILDER_H
#define REMOTEENTITYURLBUILDER_H

@interface RemoteEntityURLBuilder : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;
+ (NSString*) baseURLForEntityNamed: (NSString*) name;
- (NSString*) urlForRemoteEntity:(RemoteEntity*)remoteEntity;
- (NSString*) urlForRemoteEntitiesWithParams: (NSDictionary*)params;
- (NSString*) mapAttributesForURL: (NSDictionary*)params;
- (NSString*) getURLParamsFormat;
- (NSString*) getURLFirstPassMarker;
- (NSString*) getURLNotFirstPassMarker;
- (NSString*) urlForAllRemoteEntities;
- (NSString*) urlForAllRemoteEntitiesWithParams: (NSDictionary*) params;
- (NSString*) baseURLForEntity;
- (NSString*) urlForRemoteEntity:(RemoteEntity*)remoteEntity withParameters: (NSDictionary*) parameters;
@end

#endif
