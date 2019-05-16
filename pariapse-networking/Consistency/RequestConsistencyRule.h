//
//  RequestConsistencyRule.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 19/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestPoolItem.h"
#import "RequestConsistencyContext.h"

@interface RequestConsistencyRule : NSObject<NSCopying,NSCoding>

@property RequestConsistencyContext* context;

- (BOOL) checkConsistencyOfWRPI: (WebRequestPoolItem*)item;
- (void) applyConsistencyToWRPI: (WebRequestPoolItem*)item;

@end
