//
//  RemoteEntityManager.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WebRequestURLProperty.h"
#import "RemoteEntityDelegate.h"

#ifndef REMOTEENTITYMANAGER_H
#define REMOTEENTITYMANAGER_H

@class RemoteEntityMapper;
@class RemoteEntityURLBuilder;
@class RemoteEntityUpdater;
@class RemoteEntityFinder;
@class RemoteEntityAttributesTransformer;
@class RemoteEntityWebUpdater;
@class RemoteEntityAliasManager;
@class RemoteEntityQueryComparatorManager;
@class RemoteEntityConfigManager;

@interface RemoteEntityManager : NSObject

@property NSManagedObjectContext* context;
@property NSString* managersAttachedEntityName;
@property RemoteEntityMapper* mapper;
@property RemoteEntityAttributesTransformer* attributesTransformer;
@property RemoteEntityURLBuilder* urlBuilder;
@property RemoteEntityUpdater* updater;
@property RemoteEntityFinder* finder;
@property RemoteEntityWebUpdater* webUpdater;
@property RemoteEntityAliasManager* aliasManager;
@property RemoteEntityQueryComparatorManager* queryComparatorManager;
@property RemoteEntityConfigManager* configManager;

@property NSMutableArray* urlProperties;
@property NSMutableSet*	updateConsistencyRules;
@property NSMutableSet*	deleteConsistencyRules;
@property NSMutableSet*	createConsistencyRules;
@property NSMutableSet*	readConsistencyRules;
@property NSMutableSet* listeners;

- (void)addWebRequestProperty:(WebRequestURLProperty*)property;
- (NSArray*) getWebRequestProperties;

- (void)addListener:(id<RemoteEntityDelegate>)newDelegate;
- (void) removeListener: (id<RemoteEntityDelegate>) delegate;

-(void)remoteEntityLoaded:(RemoteEntity*)entity;
-(void)remoteEntityCreated:(RemoteEntity*)entity;
-(void)remoteEntityUpdated:(RemoteEntity*)entity;
-(void)remoteEntityDeleted:(RemoteEntity*)entity;
-(void)remoteEntitiesFinishedLoading:(NSArray*)entities;
-(void)remoteEntitiesOfflineLoaded:(NSArray*)entities;
-(void)remoteEntitiesWontBeLoadedMoreThan:(NSArray*)entities becauseOfErrorNumber:(NSUInteger)error;
-(void)remoteEntityOnError:(RemoteEntity*)entity withString:(NSString*) error andErrorCode:(NSInteger)errorCode;
@end

#endif
