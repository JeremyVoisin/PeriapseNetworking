//
//  RemoteEntityManageable.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RemoteEntity.h"
#import "RemoteEntityManager.h"

#ifndef REMOTEENTITYMANAGEABLE_H
#define REMOTEENTITYMANAGEABLE_H

@interface RemoteEntityManageable : NSObject

@property RemoteEntityManager* manager;
@property NSManagedObjectContext* contexte;

+(id)withManager:(RemoteEntityManager*)manager;
-(id)initWithManager:(RemoteEntityManager*)manager;

@end

#endif
