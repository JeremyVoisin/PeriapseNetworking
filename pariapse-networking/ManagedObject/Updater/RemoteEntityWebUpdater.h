//
//  RemoteEntityWebUpdater.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 12/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityManageable.h"

@interface RemoteEntityWebUpdater : RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager;
- (void) getAllEntitiesWithEndingBlock:(void(^)(NSArray*)) endingBlock withParams:(NSDictionary*)params;
- (NSString*) identifierForWRPI: (WebRequestPoolItem*) wrpi;
- (void) updateEntriesOnWebResult: (NSArray*) results withLocalResults:(NSArray*)localResults;

@end
