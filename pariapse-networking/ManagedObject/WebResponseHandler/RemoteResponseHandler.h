/*!
 * @header RemoteResponseHandler.h
 * @framework PeriapseNetworking

 * @author Jérémy Voisin
 * @copyright © 2019 Jérémy Voisin
 * @version 1.0
 */

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
