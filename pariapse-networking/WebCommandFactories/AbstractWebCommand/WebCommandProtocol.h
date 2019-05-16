//
//  WebRequestPoolCommand.h
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequest.h"

@protocol WebCommandProtocol <NSObject, NSCoding>

@required

@property int			priority;
@property WebRequest	*webRequest;

-(void)executeWithOnSuccess:(void(^)(NSData*))onSuccess onError:(void(^)(NSUInteger, NSHTTPURLResponse*))httpError;

@optional
@property NSObject		*toSend;

@end
