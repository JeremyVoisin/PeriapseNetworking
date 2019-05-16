//
//  RemoteEntity.h
//
//  Created by Jérémy Voisin on 25/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "RemoteEntityTransmissionState.h"
#import "RemoteEntityTransmissionStateListener.h"

@class RemoteEntityManager;
@class WebRequestPoolItem;

@interface RemoteEntity : NSManagedObject

@property BOOL shouldSendUpdates;
@property BOOL hasBeenUpdated;
@property BOOL alreadyFetched;
@property BOOL isTemporary;

@property (atomic) RemoteEntityTransmissionState transmissionState;

+ (RemoteEntityManager*) getManagerWithContext: (NSManagedObjectContext*)context;
+ (NSOrderedSet*) getInvalidOfflineAttributes;
+ (instancetype) newInstance;
+ (instancetype) newTemporaryInstance;
- (instancetype) newFromTemporarySelf;
- (NSError*) save;

- (void)read;
- (void)create;
- (void)update;
- (void)remove;
- (void)autoDelete;

- (BOOL) attributesCorrespondsToDictionary:(NSDictionary*)dict;
- (NSObject*)getIndexValue;
- (NSDictionary*) toDictionary;
- (NSDictionary*) toDictionaryFromAccumulator: (NSMutableSet*) accumulator;
- (void) setWithDictionary:(NSDictionary*) dict;
- (void) shouldNotSendUpdate;
- (BOOL) equals:(RemoteEntity*)remoteEntity;
- (BOOL) isEntityContainedInArray:(NSArray*)array;
- (RemoteEntity*)inArray:(NSArray*)array;
- (BOOL) authorizePrototypeMatching;
- (NSString*) getRemoteEntityURL;
- (void) parameteredRead: (NSDictionary*) params;

- (NSString*) stringForEntityForWRPI:(WebRequestPoolItem*) wrpi;
- (void) handleWRPIError: (WebRequestPoolItem*) wrpi errorCode: (NSInteger) errorCode;

- (void) addStateListener: (id<RemoteEntityTransmissionStateListener>)listener;
- (void) removeStateListener: (id)listener;
- (RemoteEntityManager*) getManager;

- (void) unsetConsistencyRulesIn: (NSSet*)rules;
- (NSString*) identifierForWRPI: (WebRequestPoolItem*) wrpi;
- (void) initializeWebRequestProperptiesForWRPI:(WebRequestPoolItem*)wrpi;
- (NSMutableSet*) getConsistencyRules:(NSSet*)rules;

- (BOOL) allowAutoDeleteOnGlobalUpdate;

- (NSComparisonResult) compare: (RemoteEntity*) obj2;
- (NSString*) toPermanentIdentifier;
- (NSSet*) notSendable;

@end
