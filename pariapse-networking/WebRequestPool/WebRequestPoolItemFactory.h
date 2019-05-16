//
//  WebRequestPoolItemFactory.h
//
//  Created by Jérémy Voisin on 06/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestPoolItem.h"
#import "NetworkingFactory.h"

@interface WebRequestPoolItemFactory : NSObject

+ (WebRequestPoolItemFactory*) webRequestPoolItemFactory;

- (WebRequestPoolItem*)readFromURL:(NSString*)url withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler;
- (WebRequestPoolItem*)deleteFromURL:(NSString*)url withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler;
- (WebRequestPoolItem*)postToURL:(NSString*)url withDatasToSend:(NSObject*)datas withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler;
- (WebRequestPoolItem*)updateWithURL:(NSString*)url withDatasToSend:(NSObject*)datas withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler;

@end
