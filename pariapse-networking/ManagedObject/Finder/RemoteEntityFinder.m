//
//  RemoteEntityFinder.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityFinder.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntity.h"

@implementation NSManagedObjectContext (FetchedObjectFromURI)
- (RemoteEntity*)objectWithURI:(NSURL *)uri
{
	NSManagedObjectID *objectID =
	[[self persistentStoreCoordinator]
	 managedObjectIDForURIRepresentation:uri];
	
	if (!objectID)
	{
		return nil;
	}
	
	RemoteEntity *objectForID = [self objectWithID:objectID];
	if (![objectForID isFault])
	{
		return objectForID;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[objectID entity]];
	// predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
	NSPredicate *predicate =
	[NSComparisonPredicate
	 predicateWithLeftExpression:
	 [NSExpression expressionForEvaluatedObject]
	 rightExpression:
	 [NSExpression expressionForConstantValue:objectForID]
	 modifier:NSDirectPredicateModifier
	 type:NSEqualToPredicateOperatorType
	 options:0];
	[request setPredicate:predicate];
	
	NSArray *results = [self executeFetchRequest:request error:nil];
	if ([results count] > 0 )
	{
		return [results objectAtIndex:0];
	}
	
	return nil;
}
@end

@implementation RemoteEntityFinder

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityFinder* finder = [super withManager:manager];
	[manager setFinder: finder];
	return finder;
}

+ (NSString*) permanentIdentifierFormat{
	return @"x-coredata://%@%@";
}

- (NSURL*) urlForPermanentIdentifier:(NSString*)identifier{
	NSPersistentStoreCoordinator* psc = [[[self manager] context] persistentStoreCoordinator];
	NSDictionary* metaDatas = [[[psc persistentStores] firstObject] metadata];
	NSString* storeUUID = [metaDatas objectForKey:NSStoreUUIDKey];
	NSString* permanentString = [NSString stringWithFormat:[self.class permanentIdentifierFormat],storeUUID,identifier];
	return [NSURL URLWithString:permanentString];
}

- (RemoteEntity*) findWithPermanentIdentifier: (NSString*) permanentIdentifier{
	return [[self contexte] objectWithURI: [self urlForPermanentIdentifier:permanentIdentifier]];
}

- (NSArray*) getEntitiesWithParams:(NSDictionary*) params{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: self.manager.managersAttachedEntityName];
	NSString* predicateString = [[self.manager attributesTransformer] toPredicateString:params];
	if(predicateString != nil && ![predicateString isEqualToString:@""])[fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
	return [self.contexte executeFetchRequest:fetchRequest error:nil];
}

- (NSArray*) getOfflineEntitiesWithParams:(NSDictionary*) params{
	Class remoteEntityClass = NSClassFromString(self.manager.managersAttachedEntityName);
	NSMutableDictionary* mutableParams = [params mutableCopy];
	[mutableParams removeObjectsForKeys: [[remoteEntityClass getInvalidOfflineAttributes] array]];
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: self.manager.managersAttachedEntityName];
	NSString* predicateString = [[self.manager attributesTransformer] toPredicateString:mutableParams];
	if(predicateString != nil && ![predicateString isEqualToString:@""])[fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
	return [self.contexte executeFetchRequest:fetchRequest error:nil];
}

- (NSArray*) getAllEntities{
	return [self getEntitiesWithParams:@{}];
}

- (NSArray*) lookForLocalCorrespondanceWithProperties:(NSDictionary*)properties{
	NSMutableArray* toReturn = [NSMutableArray array];
	NSArray* notAffected = [self fetchQueryWithCustomPredicateString:[[self.manager attributesTransformer] toAbsentIndexSearchingPredicateString:properties]];
	for(RemoteEntity* remoteEntity in notAffected){
		if([remoteEntity attributesCorrespondsToDictionary:[self.manager.attributesTransformer toNoIdentifierDictionary:properties]]){
			[toReturn addObject: remoteEntity];
		}
	}
	return toReturn;
}

- (NSPredicate*) constructPredicateFromDictionary: (NSObject*) attributes{
	RemoteEntityAttributesTransformer* mapper = [self.manager attributesTransformer];
	return [NSPredicate predicateWithFormat:[mapper toPredicateString:attributes]];
}

- (NSArray*) fetchQueryWithParameters:(NSObject*) parameters{
	return [self fetchQueryWithCustomPredicate:[self constructPredicateFromDictionary: parameters]];
}

- (NSArray*) fetchQueryWithCustomPredicateString:(NSString*) predicateString{
	return [self fetchQueryWithCustomPredicate:[NSPredicate predicateWithFormat:predicateString]];
}

- (NSArray*) fetchQueryWithCustomPredicate:(NSPredicate*) predicate{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.manager.managersAttachedEntityName];
	[fetchRequest setPredicate: predicate];
	return [self.contexte executeFetchRequest:fetchRequest error:nil];
}

- (NSArray*) lookForLocalUpdatableCorrespondanceWithProperties:(NSDictionary*)properties{
	NSString* propertiesPredicateString = [[self.manager attributesTransformer] toIndexSearchingPredicateString: properties];
	NSArray* concernedFields = @[];
	if(propertiesPredicateString != nil){
		concernedFields = [self fetchQueryWithCustomPredicateString:propertiesPredicateString];
	}
	if([concernedFields count] == 0)concernedFields = [[self.manager finder] lookForLocalCorrespondanceWithProperties:properties];
	return concernedFields;
}


@end
