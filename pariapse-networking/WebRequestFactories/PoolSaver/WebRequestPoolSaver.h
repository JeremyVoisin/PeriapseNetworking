//
//  WebRequestPoolSaver.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 12/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebRequestPool;

@interface WebRequestPoolSaver : NSObject

- (void) save: (WebRequestPool*)pool;
+ (NSString*) localName;
+ (WebRequestPoolSaver*) defaultSaver;

@end
