//
//  WebRequestFactoryProtocol.h
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadRequest.h"
#import "UpdateRequest.h"
#import "DeleteRequest.h"
#import "PostRequest.h"

@protocol WebRequestFactoryProtocol <NSObject>

@required

-(ReadRequest*)readRequestWithURL:(NSString*)url;
-(UpdateRequest*)updateRequestWithURL:(NSString*)url;
-(DeleteRequest*)deleteRequestWithURL:(NSString*)url;
-(PostRequest*)postRequestWithURL:(NSString*)url;

@optional

@end
