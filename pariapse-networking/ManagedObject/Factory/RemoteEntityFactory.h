//
//  RemoteEntityFactory.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 27/06/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RemoteEntityManageable.h"

@interface RemoteEntityFactory : NSObject

+ (RemoteEntityManager*) getEntityManagerForEntityNamed:(NSString*) entityName andContext:(NSManagedObjectContext*) context;
+ (RemoteEntityFactory*) getRemoteEntityFactoryNamed:(NSString*) factoryName;
+ (RemoteEntity*) createRemoteEntityWithManager:(RemoteEntityManager*)manager;
+ (RemoteEntity*) createRemoteEntityWithEntityName:(NSString*)entityName andContext:(NSManagedObjectContext*)context isTemporary:(BOOL)temporary;
+ (RemoteEntity*) createTemporaryRemoteEntityWithManager:(RemoteEntityManager*)manager;

@end
