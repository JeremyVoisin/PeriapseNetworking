//
//  WebRequest.h
//
//  Created by Jérémy Voisin on 16/09/2015.
//  Copyright (c) 2015 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestProtocol.h"
#import "NetworkStateHelper.h"
#import "NetworkStateObserver.h"
#import "WebRequestURLProperty.h"

#ifndef WebRequest_h
#define WebRequest_h

@interface WebRequest : WebRequestURLProperty<WebRequestProtocol, NSURLSessionDelegate>


- (id _Nonnull)initWithURL:(NSString* _Nonnull)url;
- (NSObject* _Nonnull) parseJSON;
+ (NSObject*_Nonnull) parseJSON:(NSData*_Nullable)response;
- (void)handleResponse:(void (^_Nonnull)(void))completion withDatas:(NSData*_Nullable)data andTheHTTPResponse:(NSURLResponse*_Nullable)resp;
+ (id _Nullable) encodeInJSON:(id _Nonnull)toEncode;

@end

#endif
