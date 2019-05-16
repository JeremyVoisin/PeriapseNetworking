//
//  RemoteResponseHandler.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 09/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebResponseHandlerProtocol.h"
#import "RemoteEntity.h"
#import "RemoteEntityManager.h"
#import "RemoteEntityFinder.h"
#import "WebRequestPoolItem.h"
#import "RemoteEntityFactory.h"

@interface RemoteResponseHandler : NSObject<WebResponseHandlerProtocol, NSCoding>

@property RemoteEntity* entity;
@property NSString* entityUUID;
@property NSString* remoteEntityName;

@end
