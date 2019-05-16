//
//  WebRequestURLProperty.h
//
//  Created by Jérémy Voisin on 05/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestURLPropertyProtocol.h"

@interface WebRequestURLProperty : NSObject<WebRequestURLPropertyProtocol>
- (void)setProperty:(id<WebRequestURLPropertyProtocol>)aProperty;
- (void)setProperties:(NSSet *)properties;
@end
