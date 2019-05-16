//
//  WebRequestURLProperty.h
//
//  Created by Jérémy Voisin on 04/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebRequestURLPropertyProtocol <NSObject, NSCoding>

@required

@property id<WebRequestURLPropertyProtocol> property;
- (void)setRequestProperty:(NSMutableURLRequest*)request;

@end
