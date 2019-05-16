//
//  RemoteEntity.m
//
//  Created by Jérémy Voisin on 25/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "RemoteEntity.h"
#import "WebRequestPoolItemFactory.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityURLBuilder.h"
#import "RemoteEntityFactory.h"
#import "RemoteEntityAttributesTransformerAdditions.h"
#import "RemoteEntityWebUpdater.h"
#import "RemoteEntityFinder.h"
#import "RequestConsistencyRule.h"
#import "RemoteReadResponseHandler.h"
#import "RemoteCreateResponseHandler.h"
#import "RemoteUpdateResponseHandler.h"
#import "RemoteDeleteResponseHandler.h"

@interface RemoteEntity()
@property RemoteEntityManager* manager;
@property NSMutableArray* stateListeners;
@end

@implementation RemoteEntity

@synthesize shouldSendUpdates;
@synthesize manager;
@synthesize hasBeenUpdated;
@synthesize alreadyFetched;
@synthesize isTemporary;
@synthesize transmissionState;
@synthesize stateListeners;

- (RemoteEntityTransmissionState) transmissionState{
	return transmissionState;
}

- (BOOL) allowAutoDeleteOnGlobalUpdate{
	return ((self.transmissionState == RemoteEntityTransmissionStateInSyncError) ? false : true);
}

- (void) setTransmissionState:(RemoteEntityTransmissionState)trState{
	transmissionState = trState;
	for(id<RemoteEntityTransmissionStateListener> listener in stateListeners){
		[listener remoteEntity: self transmissionStateChangedTo: trState];
	}
}

- (void) addStateListener: (id<RemoteEntityTransmissionStateListener>)listener{
	if(stateListeners == nil)stateListeners = [NSMutableArray array];
	[stateListeners addObject: listener];
}

- (void) removeStateListener: (id)listener{
	if(stateListeners != nil) [stateListeners removeObject: listener];
}

- (BOOL) shouldSendUpdates{
	return shouldSendUpdates && !isTemporary && [self allowAutoDeleteOnGlobalUpdate];
}

- (void) setShouldSendUpdates:(BOOL)boolToSend{
	shouldSendUpdates = boolToSend;
}

- (void) willSave{
	[super willSave];
	if([self isUpdated]){
		self.hasBeenUpdated = YES;
	}
}

- (void)didSave{
	[super didSave];
	BOOL noAction = YES;
	if([self isDeleted]){
		if([self shouldSendUpdates]){
			[self setTransmissionState: RemoteEntityTransmissionStateDeleted];
			[self remove];
		}
		else{
			[[self getManager] remoteEntityDeleted:self];
			self.shouldSendUpdates = YES;
		}
		noAction = NO;
	}
	if([self hasBeenUpdated]){
		self.hasBeenUpdated = NO;
		if([self shouldSendUpdates]){
			[self setTransmissionState: RemoteEntityTransmissionStateUpdated];
			[self update];
			[self read];
		}else{
			[[self getManager] remoteEntityUpdated:self];
			self.shouldSendUpdates = YES;
		}
		noAction = NO;
	}
	if([self isInserted]){
		self.hasBeenUpdated = NO;
		if([self shouldSendUpdates]){
			[self setTransmissionState: RemoteEntityTransmissionStateCreated];
			[self create];
		}else{
			[[self getManager] remoteEntityCreated:self];
			self.shouldSendUpdates = YES;
		}
		noAction = NO;
	}
	if(noAction)[[self getManager] remoteEntityLoaded:self];
}

- (void)awakeFromFetch{
	[super awakeFromFetch];
	if(!alreadyFetched){
		[self setShouldSendUpdates:YES];
		[self setAlreadyFetched:YES];
	}
}

+ (RemoteEntityManager*) getManagerWithContext: (NSManagedObjectContext*)context{
	return [[RemoteEntityFactory getRemoteEntityFactoryNamed:NSStringFromClass(self)].class getEntityManagerForEntityNamed:NSStringFromClass(self) andContext:context];
}

+ (NSOrderedSet*) getInvalidOfflineAttributes{
	return [NSOrderedSet orderedSet];
}

- (instancetype) newFromTemporarySelf{
	if(isTemporary){
		NSError* err;
		[[self managedObjectContext]save:&err];
		if(err != nil)
			[[self getManager] remoteEntityOnError:self withString:[err localizedDescription] andErrorCode: 0];
		[self setIsTemporary:NO];
		[self setShouldSendUpdates:YES];
		[self setTransmissionState: RemoteEntityTransmissionStateCreated];
		[self create];
	}
	return self;
}

+ (instancetype) newInstance{
	RemoteEntityManager* manager = [self getManagerWithContext:nil];
	return [RemoteEntityFactory createRemoteEntityWithManager:manager];
}

+ (instancetype) newTemporaryInstance{
	RemoteEntityManager* manager = [self getManagerWithContext:nil];
	return [RemoteEntityFactory createTemporaryRemoteEntityWithManager:manager];
}

- (RemoteEntityManager*) getManager{
	if(manager == nil)manager = [self.class getManagerWithContext:self.managedObjectContext];
	return manager;
}

- (RemoteEntityMapper*)getDataMapper{
	return [[self getManager] mapper];
}

- (NSObject*)getIndexValue{
	return [NSNumber numberWithLongLong:[[self valueForKey:[[self getManager].attributesTransformer identifierProperty]] longLongValue]];
}

- (void) shouldNotSendUpdate{
	[self setShouldSendUpdates:NO];
}

- (NSDictionary*) toDictionary{
	RemoteEntityMapper* mapper = [self getDataMapper];
	return [mapper getDictionaryFromRemoteEntity: self
						   comingFromAccumulator:[NSMutableSet setWithObject: self]
									 notSendable:[self notSendable]];
}

- (NSDictionary* _Nonnull) toDictionaryFromAccumulator: (NSMutableSet*) accumulator{
	if([accumulator containsObject:self])
		return nil;
	RemoteEntityMapper* mapper = [self getDataMapper];
	[accumulator addObject: self];
	return [mapper getDictionaryFromRemoteEntity: self
						   comingFromAccumulator: accumulator
									 notSendable:[self notSendable]];
}

- (void) setWithDictionary:(NSDictionary*) dict{
	RemoteEntityMapper* dt = [self getDataMapper];
	[dt setRemoteEntityAttributes:self fromDictionary:dict];
}

- (RemoteEntityURLBuilder*)getURLBuilder{
	return [[self getManager] urlBuilder];
}

- (NSArray*) getWebRequestProperties{
	 return [manager getWebRequestProperties];
}

- (void) initializeWebRequestProperptiesForWRPI:(WebRequestPoolItem*)wrpi{
	for(__strong WebRequestURLProperty* c in [self getWebRequestProperties]){
		[wrpi setRequestProperty:c];
	}
}

- (BOOL) equals:(RemoteEntity*)remoteEntity{
	return [self attributesCorrespondsToDictionary:[remoteEntity toDictionary]];
}

- (BOOL)testEqualityWith:(NSDictionary*)entityDatas{
	return [self attributesCorrespondsToDictionary: entityDatas];
}

- (BOOL) authorizePrototypeMatching{
	return true;
}

- (BOOL) attributesCorrespondsToDictionary:(NSDictionary*)dict{
	BOOL toReturn = true;
	for(__strong NSString* key in dict){
		NSObject* obj = [[self getDataMapper] mapObjectForPath: key inEntity:self];
		NSObject* testedObject = [dict objectForKey:key];
		if(obj == nil && [self authorizePrototypeMatching])continue;
		toReturn &= (obj != nil && [obj testEqualityWith:testedObject]);
		if(!toReturn)break;
	}
	return toReturn;
}

- (BOOL) isEntityContainedInArray:(NSArray*)array{
	return [self inArray:array] != nil;
}

- (RemoteEntity*)inArray:(NSArray*)array{
	RemoteEntity* toReturn = nil;
	for(__strong RemoteEntity* ent in array){
		if([self equals:ent]){
			toReturn = ent;
			break;
		}
	}
	return toReturn;
}

- (NSString*) getRemoteEntityURL{
	return [[self getURLBuilder] urlForRemoteEntity:self];
}

- (NSString*) stringForEntityForWRPI:(WebRequestPoolItem*) wrpi{
	return [NSString stringWithFormat:@"Request error: %@ for \n%@",NSStringFromClass(wrpi.command.webRequest.class),[self.entity name]];
}

- (void) handleWRPIError: (WebRequestPoolItem*) wrpi errorCode: (NSInteger) errorCode{
	if(errorCode >= 500){
		[wrpi wontEnd];
		[self setTransmissionState: RemoteEntityTransmissionStateInSyncError];
	}
	[[self getManager] remoteEntityOnError: self withString: [self stringForEntityForWRPI : wrpi] andErrorCode: errorCode];
}

- (NSString*) identifierForWRPI: (WebRequestPoolItem*) wrpi{
	return [[[self getManager] webUpdater]identifierForWRPI: wrpi];
}

- (void) parameteredRead: (NSDictionary*) params{
	[self readWithURL:[[self getURLBuilder] urlForRemoteEntity: self withParameters: params]];
}

- (void) read{
	[self readWithURL:[self getRemoteEntityURL]];
}

- (NSComparisonResult) compare: (RemoteEntity*) obj2{
	NSComparisonResult toReturn;
	if ([self objectID] > [obj2 objectID]) {
		toReturn = (NSComparisonResult)NSOrderedDescending;
	}else if ([self objectID] < [obj2 objectID]) {
		toReturn = (NSComparisonResult)NSOrderedAscending;
	}else{
		toReturn = NSOrderedSame;
	}
	return toReturn;
};

- (void)readWithURL: (NSString*) url{
	if(url != nil){
		RemoteResponseHandler* responseHandler = [self getReadResponseHandler];
		WebRequestPoolItem* wrpi = [[WebRequestPoolItemFactory webRequestPoolItemFactory] readFromURL:url withResponseHandler: responseHandler];
		[responseHandler setEntity: self];
		[wrpi setIdentifier: [self identifierForWRPI: wrpi]];
		[wrpi setAsync:NO];
		[wrpi setIndependency:NO];
		[self initializeWebRequestProperptiesForWRPI:wrpi];
		[wrpi setConsistencyRules:[self getConsistencyRules:[[self getManager] readConsistencyRules]]];
		[wrpi setReady];
	}
}

- (void)create{
	NSString* url = [[self getURLBuilder] baseURLForEntity];
	if(url != nil){
		RemoteResponseHandler* responseHandler = [self getCreateResponseHandler];
		WebRequestPoolItem* wrpi = [[WebRequestPoolItemFactory webRequestPoolItemFactory] postToURL:url withDatasToSend:[self toDictionary] withResponseHandler: responseHandler];
		[responseHandler setEntity: self];
		[wrpi setIdentifier: [self identifierForWRPI: wrpi]];
		[wrpi setAsync:NO];
		[wrpi setIndependency:NO];
		[self initializeWebRequestProperptiesForWRPI:wrpi];
		[wrpi setConsistencyRules:[self getConsistencyRules:[[self getManager] createConsistencyRules]]];
		[wrpi setReady];
	}
}

- (void)update{
	NSString* url = [self getRemoteEntityURL];
	if(url != nil){
		RemoteResponseHandler* responseHandler = [self getUpdateResponseHandler];
		WebRequestPoolItem* wrpi = [[WebRequestPoolItemFactory webRequestPoolItemFactory] updateWithURL:url withDatasToSend:[self toDictionary] withResponseHandler: responseHandler];
		[responseHandler setEntity: self];
		[wrpi setIdentifier: [self identifierForWRPI: wrpi]];
		[wrpi setAsync:NO];
		[wrpi setIndependency:NO];
		[self initializeWebRequestProperptiesForWRPI:wrpi];
		[wrpi setConsistencyRules:[self getConsistencyRules:[[self getManager] updateConsistencyRules]]];
		[wrpi setReady];
	}
}

- (void)remove{
	NSString* url = [self getRemoteEntityURL];
	if(url != nil){
		RemoteResponseHandler* responseHandler = [self getDeleteResponseHandler];
		WebRequestPoolItem* wrpi = [[WebRequestPoolItemFactory webRequestPoolItemFactory] deleteFromURL:url withResponseHandler:responseHandler];
		[responseHandler setEntity: self];
		[wrpi setIdentifier: [self identifierForWRPI: wrpi]];
		[wrpi setAsync:NO];
		[wrpi setIndependency:NO];
		[self initializeWebRequestProperptiesForWRPI:wrpi];
		[wrpi setConsistencyRules:[self getConsistencyRules:[[self getManager] deleteConsistencyRules]]];
		[wrpi setReady];
	}
}

- (NSMutableSet*) getConsistencyRules:(NSSet*)rules{
	NSMutableSet* toReturn = [NSMutableSet set];
	for(RequestConsistencyRule* rule in rules){
		RequestConsistencyRule* newRule = [rule copy];
		[newRule.context setObject:self ForKey:@"entity"];
		[newRule.context setObject:[self toPermanentIdentifier] ForKey:@"entityURI"];
		[newRule.context setObject:self.entity.name ForKey:@"entityIdURI"];
		[newRule.context setObject:[self toDictionary] ForKey:@"entityDictionary"];
		if([newRule conformsToProtocol: @protocol(RemoteEntityTransmissionStateListener)]){
			RequestConsistencyRule<RemoteEntityTransmissionStateListener>* theRule = (RequestConsistencyRule<RemoteEntityTransmissionStateListener>*)newRule;
			[self addStateListener: theRule];
			[theRule remoteEntity: self transmissionStateChangedTo: self.transmissionState];
		}
		[toReturn addObject:newRule];
	}
	return toReturn;
}

- (NSSet*) notSendable{
	return [NSSet set];
}

- (void) unsetConsistencyRulesIn: (NSSet*)rules{
	for(RequestConsistencyRule* rule in rules) {
		[self removeStateListener: rule];
	}
}

- (NSString*) toPermanentIdentifier{
	return [[self getDataMapper] toPermanentIdentifier:self];
}

+ (RemoteEntity*) fromPermanentIdentifier: (NSString*) identifier{
	return [[[self getManagerWithContext:nil] finder] findWithPermanentIdentifier: identifier];
}

- (void) autoDelete{
	[self.managedObjectContext deleteObject: self];
	[self.managedObjectContext save: nil];
}

- (NSError*) save{
	NSError* error;
	[self.managedObjectContext save: &error];
	return error;
}

- (RemoteResponseHandler*) getReadResponseHandler{
	return [RemoteReadResponseHandler new];
}

- (RemoteResponseHandler*) getCreateResponseHandler{
	return [RemoteCreateResponseHandler new];
}

- (RemoteResponseHandler*) getUpdateResponseHandler{
	return [RemoteUpdateResponseHandler new];
}

- (RemoteResponseHandler*) getDeleteResponseHandler{
	return [RemoteDeleteResponseHandler new];
}
@end
