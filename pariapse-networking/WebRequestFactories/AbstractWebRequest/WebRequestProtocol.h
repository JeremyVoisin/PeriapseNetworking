//
//  WebRequestProtocol.h
//
//  Created by Jérémy Voisin on 10/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestURLPropertyProtocol.h"

@protocol WebRequestProtocol <NSObject, NSCoding>

@required
@property NSString * _Nonnull url;
@property NSData * _Nullable response;
@property long int httpStatus;
@property NSHTTPURLResponse* _Nonnull httpURLResponse;

-(void) sendRequestWithEndingBlock:(void(^_Nonnull)(void))completion;

@optional
@property NSData * _Nonnull toSend;
@property BOOL isAsync;

@end
