//
//  NetworkStateHelper.h
//
//  Created by Jérémy Voisin on 31/03/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkState.h"

@interface NetworkStateHelper : NSObject

+(BOOL)cellularConnected;
+(BOOL)networkConnected;
+(BOOL)wiFiConnected;
+(BOOL)isReachable;
+(NetworkState) networkType;

@end
