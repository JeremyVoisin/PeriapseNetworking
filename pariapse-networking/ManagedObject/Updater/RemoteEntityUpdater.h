//
//  RemoteEntityUpdater.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntityManageable.h"

@interface RemoteEntityUpdater : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;
- (BOOL) updateEntity: (RemoteEntity*) entity withDatas:(NSDictionary*)datas;
- (BOOL) updateEntityIdentifiedByParams: (NSDictionary*) params withDatas:(NSDictionary*)datas;
- (NSArray*) updateAllLocalEntriesCorrespondingToDatas: (NSArray*) datas;

@end
