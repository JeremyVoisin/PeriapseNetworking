//
//  RemoteEntityConfigManager.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 27/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <PeriapseNetworking/PeriapseNetworking.h>

@interface RemoteEntityConfigManager : RemoteEntityManageable

- (NSDictionary*)getConfigFromName:(NSString*)name;
- (NSDictionary*)loadConfig;

@end
