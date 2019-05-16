//
//  RemoteEntityAliasManager.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 21/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <PeriapseNetworking/PeriapseNetworking.h>

@interface RemoteEntityAliasManager : RemoteEntityManageable

- (NSString*)getPropertyNameFromAlias:(NSString*)alias;

@end
