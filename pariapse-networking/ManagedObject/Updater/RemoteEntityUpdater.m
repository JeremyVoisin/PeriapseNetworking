//
//  RemoteEntityUpdater.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityUpdater.h"
#import "RemoteEntityFinder.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityFactory.h"

@implementation NSObject(RemoteEntityUpdaterAdditions)

+ (id) transformFromResult: (id) obj{
	return obj;
}

@end

@implementation NSData(RemoteEntityUpdaterAdditions)

+ (NSData*) transformFromResult: (NSString*) obj{
	return (obj!=nil)?[[NSData alloc] initWithBase64EncodedString: [self base64StringFromBase64UrlEncodedString: obj] options:0]:nil;
}

+(NSString *)base64StringFromBase64UrlEncodedString:(NSString *)base64UrlEncodedString{
	NSString *s = base64UrlEncodedString;
	s = [s stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
	s = [s stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
	switch (s.length % 4) {
		case 2:
			s = [s stringByAppendingString:@"=="];
			break;
		case 3:
			s = [s stringByAppendingString:@"="];
			break;
		default:
			break;
	}
	return s;
}


@end

@implementation RemoteEntityUpdater

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityUpdater* updater = [super withManager:manager];
	[manager setUpdater:updater];
	return updater;
}

- (NSObject*) transformDatasToSet:(NSObject*)toSet inEntity: (RemoteEntity*) entity forKey: (NSString*) key{
	NSObject* toReturn = toSet;
	if(toSet == [NSNull null])toReturn = nil;
	toReturn = [NSClassFromString([[[entity.entity attributesByName]objectForKey:key] attributeValueClassName]) transformFromResult: toReturn];
	return toReturn;
}

- (BOOL) updateEntity: (RemoteEntity*) entity withDatas:(NSDictionary*)datas{
	for(NSString* key in [datas allKeys]){
		if([[[entity.entity attributesByName]allKeys]containsObject:key]){
			id toSet = [self transformDatasToSet:[datas objectForKey:key] inEntity:entity forKey: key];
			[entity setValue:toSet forKey:key];
		}
		else if([[[entity.entity relationshipsByName]allKeys] containsObject:key]){
			NSRelationshipDescription* relationship = [[entity.entity relationshipsByName] objectForKey:key];
			NSString* entityClassName = [[[entity.entity relationshipsByName] objectForKey:key].destinationEntity name];
			RemoteEntityManager* secManager = [RemoteEntityFactory getEntityManagerForEntityNamed:entityClassName andContext:self.manager.context];
			if([relationship isToMany]){
		
				NSMutableOrderedSet *entitySet = [relationship isOrdered]?[entity mutableOrderedSetValueForKey:key]:[NSMutableOrderedSet orderedSetWithSet:[entity mutableSetValueForKey:key]];
				NSMutableArray* arr = [[datas objectForKey:key] mutableCopy];
				NSMutableArray* toRemove = [NSMutableArray arrayWithCapacity:arr.count];
				NSMutableArray* toKeep = [NSMutableArray arrayWithCapacity:entitySet.count];
				
				for(__strong RemoteEntity* ent in entitySet){
					for(NSDictionary* nsd in arr){
						if([[secManager mapper] areProperties:[[secManager attributesTransformer] toIdentifierDictionary:nsd] correspondingToRemoteEntitysAttribute:ent]){
							[ent shouldNotSendUpdate];
							[[secManager updater] updateEntity:ent withDatas:nsd];
							[toRemove addObject:nsd];
							[toKeep addObject:ent];
						}
					}
				}
				
				[arr removeObjectsInArray:toRemove];
				
				NSArray* updated = [[secManager updater] updateAllLocalEntriesCorrespondingToDatas:arr];
				[entitySet removeAllObjects];
				[entitySet addObjectsFromArray:toKeep];
				[entitySet addObjectsFromArray:updated];
				
				
				[entity setValue: [relationship isOrdered]?entitySet:[NSMutableSet setWithArray:[entitySet array]] forKey:key];
				
			}
			else{
				[entity setValue:[[[secManager updater] updateAllLocalEntriesCorrespondingToDatas:@[[datas objectForKey:key]]] firstObject] forKey:key];
			}
		}
	}
	return true;
}

- (BOOL) updateEntityIdentifiedByParams: (NSDictionary*) params withDatas:(NSDictionary*)datas{
	BOOL updated = false;
	RemoteEntityFinder* finder = [[self manager] finder];
	NSArray* finderResults = [finder getEntitiesWithParams:datas];
	for(__strong RemoteEntity* re in finderResults){
		updated |= [self updateEntity:re withDatas:datas];
	}
	return updated;
}

- (NSArray*) updateAllLocalEntriesCorrespondingToDatas: (NSArray*) datas{
	NSMutableArray* toReturn = [NSMutableArray array];
	for(NSDictionary* properties in datas){
		NSArray* concernedFields  = [[[self manager]finder] lookForLocalUpdatableCorrespondanceWithProperties:properties];
		if([concernedFields count]>0){
			for(__strong RemoteEntity* entity in concernedFields){
				[entity setWithDictionary:properties];
				[entity shouldNotSendUpdate];
				[toReturn addObject:entity];
			}
		}else{
			RemoteEntity* newEntry = [RemoteEntityFactory createRemoteEntityWithManager:self.manager];
			[newEntry setWithDictionary: properties];
			[newEntry shouldNotSendUpdate];
			[toReturn addObject:newEntry];
		}
	}
	return toReturn;
}

@end
