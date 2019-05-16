//
//  RemoteEntityAttributesTransformerAdditions.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 21/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntityManager.h"

@interface NSObject(RemoteEntityAddition)
- (NSObject*)transformRequestParamsWithAliasesWithManager:(RemoteEntityManager*) entityManager;
- (NSString*) toURLParamsWithURLBuilder:(RemoteEntityURLBuilder*)urlBuilder;
- (NSString*) toURLParamsWithFirstPass:(BOOL)firstPass andTitle:(NSString*)title andURLBuilder:(RemoteEntityURLBuilder*)urlBuilder;
- (NSString*) getURLMarkerWithFirstPass:(BOOL)firstPass andURLBuilder:(RemoteEntityURLBuilder*)urlBuilder;
- (NSString*) toPredicateStringWithManager:(RemoteEntityManager*)manager;
- (NSString*) toPredicateStringWithPrefix:(NSString*) prefix andManager:(RemoteEntityManager*)manager;
- (BOOL)testEqualityWith:(id)object;
@end

@interface NSString(RemoteEntityAddition)
- (NSString*)getPrefixWithPreviousPrefix:(NSString*)previousPrefix;
@end
