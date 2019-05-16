//
//  DataScenariosManager.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 18/04/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataScenariosEntity.h"

@interface DataScenariosManager : NSObject<NSCoding>

+(DataScenariosManager*)defaultScenariosManager;
+(DataScenariosManager*)scenariosManager;

-(NSArray*)getRootEntities;
-(NSArray*)getEntitiesForKey:(NSString*)key;
-(long)getRootEntitiesNumberForKey:(NSString*)key;
-(void)addEntity:(id<DataScenariosEntity>)entity;
-(void)addEntity:(id<DataScenariosEntity>)entity async:(BOOL)async;
-(void)addEntity:(id<DataScenariosEntity>)entity independency:(BOOL)independency;
-(void)addEntity:(id<DataScenariosEntity>)entity async:(BOOL)async independency:(BOOL)independency;
-(void)removeEntity:(id<DataScenariosEntity>)entity;
-(void)resetScenarios;
@end
