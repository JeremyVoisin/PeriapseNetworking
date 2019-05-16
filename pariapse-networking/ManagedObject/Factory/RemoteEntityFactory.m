//
//  RemoteEntityFactory.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 27/06/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityFactory.h"

@implementation RemoteEntityFactory

static NSMutableDictionary* managers = nil;

+ (RemoteEntityFactory*) getRemoteEntityFactoryNamed:(NSString*) factoryName{
	RemoteEntityFactory* factoryInstance;
	NSString* potentialPropertyName = [NSString stringWithFormat:@"%@Factory", factoryName];
	Class potentialPropertyClass = NSClassFromString (potentialPropertyName);
	if(potentialPropertyClass != nil && [potentialPropertyClass isSubclassOfClass:self])
		factoryInstance = [potentialPropertyClass new];
	else factoryInstance = [self new];
	return factoryInstance;
}

+ (RemoteEntityManager*) getEntityManagerForEntityNamed:(NSString*) entityName andContext:(NSManagedObjectContext*) context{
#ifdef VERBOSE_MODE
	NSLog(@"Getting %@ manager with %@ as a context", entityName, context);
#endif
	RemoteEntityManager* managerToReturn;
	if(managers == nil)managers = [NSMutableDictionary dictionary];
	if([[managers allKeys]containsObject: entityName]){
		if(context != nil)managerToReturn.context = context;
		managerToReturn = [managers objectForKey:entityName];
	}
	else{
		if(context == nil){
			NSString* error = [NSString stringWithFormat:@"Error, attempting to initialize RemoteEntityManager for %@ without a context.\nExisting managers : %@", entityName, [managers allKeys]];
			@throw [NSException exceptionWithName:NSInternalInconsistencyException
										   reason: error userInfo:nil];
		}
		managerToReturn = [self rawEntityManager];
		managerToReturn.managersAttachedEntityName = entityName;
		managerToReturn.context = context;
		managerToReturn.urlProperties = [NSMutableArray array];
		managerToReturn.listeners = [NSMutableSet set];
		managerToReturn.updateConsistencyRules = [NSMutableSet set];
		managerToReturn.deleteConsistencyRules = [NSMutableSet set];
		managerToReturn.createConsistencyRules = [NSMutableSet set];
		managerToReturn.readConsistencyRules = [NSMutableSet set];
		
		[self initializeManagers:managerToReturn property:@"Mapper"];
		[self initializeManagers:managerToReturn property:@"AttributesTransformer"];
		[self initializeManagers:managerToReturn property:@"URLBuilder"];
		[self initializeManagers:managerToReturn property:@"Updater"];
		[self initializeManagers:managerToReturn property:@"Finder"];
		[self initializeManagers:managerToReturn property:@"WebUpdater"];
		[self initializeManagers:managerToReturn property:@"AliasManager"];
		[self initializeManagers:managerToReturn property:@"QueryComparatorManager"];
		[self initializeManagers:managerToReturn property:@"ConfigManager"];
		
		[managers setObject:managerToReturn forKey:entityName];
	}
	
	return managerToReturn;
}

+ (RemoteEntityManager*) rawEntityManager{
	return [[RemoteEntityManager alloc] init];
}

+ (void) initializeManagers:(RemoteEntityManager*)manager property:(NSString*)managerProperty{
	NSString* potentialPropertyName = [NSString stringWithFormat:@"%@%@",manager.managersAttachedEntityName,managerProperty];
	NSString* defaultPropertyName = [NSString stringWithFormat:@"RemoteEntity%@",managerProperty];
	Class potentialPropertyClass = NSClassFromString (potentialPropertyName);
	Class entityClass = NSClassFromString(manager.managersAttachedEntityName);
	Class defaultPropertyClass = NSClassFromString (defaultPropertyName);
	if(potentialPropertyClass != nil && [potentialPropertyClass isSubclassOfClass:defaultPropertyClass])
		[potentialPropertyClass withManager: manager];
	else{
		Class superClass = entityClass;
		while((superClass = [superClass superclass])){
			NSString* otherPotentialPropertyName = [NSString stringWithFormat:@"%@%@",NSStringFromClass(superClass),managerProperty];
			Class otherPotentialPropertyClass = NSClassFromString(otherPotentialPropertyName);
			if(otherPotentialPropertyClass != nil && ([otherPotentialPropertyClass isSubclassOfClass:defaultPropertyClass]||otherPotentialPropertyClass == defaultPropertyClass)){
				[otherPotentialPropertyClass withManager: manager];
				break;
			}
		}
	}
}

+ (RemoteEntity*) createTemporaryRemoteEntityWithManager:(RemoteEntityManager*)manager{
	return [self createRemoteEntityWithEntityName:manager.managersAttachedEntityName andContext:manager.context isTemporary: YES];
}

+ (RemoteEntity*) createRemoteEntityWithManager:(RemoteEntityManager*)manager{
	return [self createRemoteEntityWithEntityName:manager.managersAttachedEntityName andContext:manager.context isTemporary: NO];
}

+ (RemoteEntity*) createRemoteEntityWithEntityName:(NSString*)entityName andContext:(NSManagedObjectContext*)context isTemporary:(BOOL)temporary{
	RemoteEntity* newEntity = [NSEntityDescription
							   insertNewObjectForEntityForName: entityName
							   inManagedObjectContext: context];
	[newEntity setShouldSendUpdates:!temporary];
	[newEntity setHasBeenUpdated:NO];
	[newEntity setIsTemporary:temporary];
	[newEntity setTransmissionState: RemoteEntityTransmissionStateCreated];
	return newEntity;
}

@end
