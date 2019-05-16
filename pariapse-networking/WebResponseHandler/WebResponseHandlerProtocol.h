//
//  WebResponseHandlerProtocol.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebRequestPoolItem;

@protocol WebResponseHandlerProtocol <NSObject>

@required

- (void) onSuccess:(NSData*) datas withWRPI: (WebRequestPoolItem*)wrpi;
- (void) onError:(NSUInteger) errorCode withURLResponse: (NSHTTPURLResponse*) httpError withWRPI: (WebRequestPoolItem*)wrpi;
- (void) onOfflineWithWRPI: (WebRequestPoolItem*)wrpi;

@end
