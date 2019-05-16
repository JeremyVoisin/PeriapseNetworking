//
//  RemoteEntityAttributesTransformer.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntityManageable.h"

#ifndef REMOTEENTITYATTRIBUTESTRANSFORMER_H
#define REMOTEENTITYATTRIBUTESTRANSFORMER_H

@interface RemoteEntityAttributesTransformer : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;
- (NSString*) toURLParamsFromDatas:(NSObject*)datas;
- (NSString*) toPredicateString:(NSObject*) properties;
- (NSString*) toIndexSearchingPredicateString:(NSDictionary*) properties;
- (NSString*) toAbsentIndexSearchingPredicateString:(NSDictionary*) properties;
- (NSArray*) toArray:(NSDictionary*) properties;
- (NSDictionary*) toIdentifierDictionary:(NSDictionary*) _properties;
- (NSObject*)transformRequestParamsWithAliases:(NSObject*)params;
- (NSDictionary*) toNoIdentifierDictionary:(NSDictionary*) _properties;
- (NSString*) identifierProperty;

@end

#endif
