//
//  periapse-networking.h
//  periapse-networking
//
//  Created by Jérémy Voisin on 07/04/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for periapse-networking.
FOUNDATION_EXPORT double periapse_networkingVersionNumber;

//! Project version string for periapse-networking.
FOUNDATION_EXPORT const unsigned char periapse_networkingVersionString[];

//Config
#import "NetConfig.h"

//Consistency rules
#import "RequestConsistencyRule.h"
#import "RequestConsistencyContext.h"

//Request pool
#import "WebRequestPool.h"
#import "WebRequestPoolActivityListener.h"

//Requests
#import "StandardReadRequest.h"
#import "StandardPostRequest.h"
#import "StandardUpdateRequest.h"
#import "StandardDeleteRequest.h"

#import "ReadRequest.h"
#import "PostRequest.h"
#import "UpdateRequest.h"
#import "DeleteRequest.h"

#import "WebRequestSerializerProtocol.h"
#import "JSONWebRequestSerializer.h"

//Response handler
#import "WebResponseHandlerProtocol.h"
#import "RemoteReadAllResponseHandler.h"
#import "RemoteReadResponseHandler.h"
#import "RemoteCreateResponseHandler.h"
#import "RemoteResponseHandler.h"
#import "RemoteUpdateResponseHandler.h"
#import "RemoteDeleteResponseHandler.h"

//Requests factories

#import "StandardWebRequestFactory.h"
#import "WebRequestFactory.h"
#import "StandardWebCommandFactory.h"
#import "WebCommandFactory.h"
#import "NetworkingFactory.h"

//Network state
#import "NetworkState.h"
#import "NetworkStateObserver.h"
#import "NetworkStateHelper.h"
#import "NetworkStateSubscriber.h"
#import "Reachability.h"
#import "RemoteEntityTransmissionState.h"
#import "RemoteEntityTransmissionStateListener.h"

//WRPI
#import "WebRequestPoolItem.h"
#import "WebRequestPoolItemDelegate.h"
#import "WebRequestPoolItemFactory.h"

#import "WebRequest.h"

//Protocols
#import "WebCommandProtocol.h"
#import "WebRequestProtocol.h"
#import "WebCommandFactoryProtocol.h"
#import "WebRequestFactoryProtocol.h"
#import "WebRequestURLPropertyProtocol.h"

#import "WebRequestURLProperty.h"

//Remote entities
#import "RemoteEntity.h"
#import "RemoteEntityURLBuilder.h"
#import "RemoteEntityDelegate.h"
#import "RemoteEntityFinder.h"
#import "RemoteEntityUpdater.h"
#import "RemoteEntityWebUpdater.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityManager.h"
#import "RemoteEntityManageable.h"
#import "RemoteEntityFactory.h"
#import "RemoteEntityAliasManager.h"
#import "RemoteEntityQueryComparatorManager.h"
#import "RemoteEntityAttributesTransformerAdditions.h"

//Data scenarios
#import "DataScenariosManager.h"
#import "RemoteEntityConfigManager.h"

//Offline saver
#import "WebRequestPoolSaver.h"
#import "WebRequestPoolLoader.h"
