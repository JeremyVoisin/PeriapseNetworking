//
//  RemoteEntityDelegate.h
//
//  Created by Jérémy Voisin on 25/03/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RemoteEntity;

@protocol RemoteEntityDelegate <NSObject>

@optional
- (void)remoteEntitiesFinishedLoading:(NSArray*)entities;
- (void)remoteEntitiesOfflineLoaded:(NSArray*)entities;
- (void)remoteEntitiesWontBeLoadedMoreThan:(NSArray*)entities becauseOfErrorNumber:(NSUInteger)error;

- (void)remoteEntityLoaded: (RemoteEntity*)entity;
- (void)remoteEntityUpdated:(RemoteEntity*)entity;
- (void)remoteEntityCreated:(RemoteEntity*)entity;
- (void)remoteEntityDeleted:(RemoteEntity*)entity;
- (void)remoteEntityOnError:(RemoteEntity*)entity withErrorString: (NSString*) error andErrorCode:(NSInteger)errorCode;

@end
