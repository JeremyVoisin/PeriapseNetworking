//
//  RemoteEntityMapper.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityMapper.h"
#import "RemoteEntityUpdater.h"

@implementation RemoteEntityMapper

- (NSDictionary*) getDictionaryFromRemoteEntity:(RemoteEntity*) entity
						comingFromAccumulator:(NSMutableSet*)accumulator
									notSendable:(NSSet*)notSendable{
	NSArray *keys = [[[entity entity] attributesByName] allKeys];
	
	NSMutableDictionary* toReturn = [NSMutableDictionary dictionaryWithDictionary:[entity dictionaryWithValuesForKeys:keys]];
	
	NSDictionary* relationships = [entity.entity relationshipsByName];
	for(NSString* relationshipKey in [relationships allKeys]){
		if(![notSendable containsObject:relationshipKey]){
			NSRelationshipDescription* relationship = [relationships objectForKey:relationshipKey];
			if([relationship isToMany]){
				NSObject<NSFastEnumeration>* entities = [relationship isOrdered]?[entity mutableOrderedSetValueForKey:relationshipKey]:[entity mutableSetValueForKey:relationshipKey];
				NSMutableArray* entitiesToReturn = [NSMutableArray array];
				for(RemoteEntity* anEntity in entities){
					NSDictionary* dict = [anEntity toDictionaryFromAccumulator: accumulator];
					if(dict != nil)
						[entitiesToReturn addObject: dict];
				}
				[toReturn setObject:entitiesToReturn forKey:relationshipKey];
			}else{
				RemoteEntity* entityToReturn = [entity valueForKey:relationshipKey];
				if(entityToReturn != nil){
					NSDictionary* dict = [entityToReturn toDictionaryFromAccumulator: accumulator];
					if(dict != nil)
						[toReturn setObject: dict forKey:relationshipKey];
				}
			}
		}
	}
	
	[toReturn removeObjectsForKeys: [toReturn allKeysForObject:[NSNull null]]];
	
	return toReturn;
}

- (NSString*) toPermanentIdentifier: (RemoteEntity*) entity{
	[self.contexte obtainPermanentIDsForObjects:@[entity] error:nil];
	return [[entity.objectID URIRepresentation] relativePath];
}

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityMapper* mapper = [super withManager:manager];
	[manager setMapper:mapper];
	return mapper;
}

- (void) setRemoteEntityAttributes:(RemoteEntity*) entity fromDictionary:(NSDictionary*) dict{
	RemoteEntityUpdater* updater = [self.manager updater];
	[updater updateEntity: entity withDatas: dict];
}

- (RemoteEntityManager*) mapEntityManagerForPath:(NSString*) path{
	RemoteEntityManager* toReturn = nil;
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.manager.managersAttachedEntityName inManagedObjectContext:self.manager.context];
	if([path isEqualToString:@""] || [[[entityDescription attributesByName] allKeys] containsObject:path]){
		toReturn = self.manager;
	}else{
		NSMutableArray* arr = [[path componentsSeparatedByString:@"."] mutableCopy];
		NSString* propertyPartName = [arr firstObject];
		if([[[entityDescription relationshipsByName] allKeys] containsObject:propertyPartName]){
			[arr removeObject:propertyPartName];
			NSString* restingPropertyName = [arr componentsJoinedByString:@"."];
			NSEntityDescription* destination = [[[entityDescription relationshipsByName] objectForKey:propertyPartName] destinationEntity];
			RemoteEntityMapper* propertyMapper = [NSClassFromString([destination name]) getManagerWithContext: self.contexte].mapper;
			toReturn = [propertyMapper mapEntityManagerForPath:restingPropertyName];
		}
	}
	return toReturn;
}

- (NSObject*) mapObjectForPath:(NSString *)path inEntity:(RemoteEntity *)entity{
	NSObject* obj = nil;
	for(int i = 0; i < 3 && obj == nil; i++){
		switch(i){
			case 0:
				obj = [self mapAttributeForPath:path inEntity:entity];
			break;
			case 1:
				obj = [self mapUnaryRelationshipForPath:path inEntity:entity];
			break;
			case 2:
				obj = [self mapNaryRelationshipForPath:path inEntity:entity];
			break;
		}
	}
	return obj;
}

- (NSObject*) mapAttributeForPath:(NSString*)path inEntity:(RemoteEntity*)entity{
	NSObject* toReturn = nil;
	NSEntityDescription *entityDescription = [entity entity];
	if([[[entityDescription attributesByName] allKeys] containsObject:path]){
		toReturn = [entity valueForKey:path];
	}
	return toReturn;
}

- (RemoteEntity*) mapUnaryRelationshipForPath:(NSString*)path inEntity: (RemoteEntity*)entity{
	RemoteEntity* toReturn = nil;
	NSEntityDescription *entityDescription = [entity entity];
	NSDictionary* relationships = [entityDescription relationshipsByName];
	if([[relationships allKeys] containsObject:path] && ![[relationships objectForKey:path] isToMany]){
		toReturn = [entity valueForKey:path];
	}
	return toReturn;
}

- (NSArray*) mapNaryRelationshipForPath:(NSString*)path inEntity: (RemoteEntity*)entity{
	NSArray* toReturn = nil;
	NSEntityDescription *entityDescription = [entity entity];
	NSDictionary* relationships = [entityDescription relationshipsByName];
	if([[relationships allKeys] containsObject:path] && [[relationships objectForKey:path] isToMany]){
		toReturn = [[relationships objectForKey:path] isOrdered]?[[entity mutableOrderedSetValueForKey:path] array]:[[entity mutableSetValueForKey:path] allObjects];
	}
	return toReturn;
}

- (BOOL) isPropertyExisting: (NSString*)propertyName{
	return ([self mapEntityManagerForPath:propertyName] != nil);
}

- (BOOL) areProperties:(NSDictionary*) properties correspondingToRemoteEntitysAttribute:(RemoteEntity*) remoteEntity{
	return [remoteEntity attributesCorrespondsToDictionary:properties];
}

@end
