//
//  RemoteEntityQueryComparatorManager.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 26/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <PeriapseNetworking/PeriapseNetworking.h>

@interface RemoteEntityQueryComparatorManager : RemoteEntityManageable

- (NSString*)getQueryComparatorFromPropertyName:(NSString*)alias;

@end
