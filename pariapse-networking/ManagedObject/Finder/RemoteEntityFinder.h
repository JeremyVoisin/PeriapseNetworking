//
//  RemoteEntityFinder.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RemoteEntityManageable.h"

@interface RemoteEntityFinder : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;

- (NSArray*) getEntitiesWithParams:(NSDictionary*) params;
- (NSArray*) getOfflineEntitiesWithParams:(NSDictionary*) params;
- (NSArray*) getAllEntities;
- (NSArray*) lookForLocalCorrespondanceWithProperties:(NSDictionary*)properties;
- (NSArray*) fetchQueryWithParameters:(NSDictionary*) parameters;
- (NSArray*) fetchQueryWithCustomPredicateString:(NSString*) predicateString;
- (NSArray*) fetchQueryWithCustomPredicate:(NSPredicate*) predicate;
- (NSArray*) lookForLocalUpdatableCorrespondanceWithProperties:(NSDictionary*)properties;
- (RemoteEntity*) findWithPermanentIdentifier: (NSString*) permanentIdentifier;

@end
