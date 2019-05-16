//
//  RequestConsistencyContext.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 19/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestConsistencyContext : NSObject<NSCopying,NSCoding>

@property NSMutableDictionary *cont;
- (id) getObjectForKey: (NSString*) key;
- (void) setObject:(NSObject*) object ForKey: (NSString*) key;

@end
