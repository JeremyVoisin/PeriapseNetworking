//
//  RemoteEntityTransmissionState.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 21/10/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#ifndef RemoteEntityTransmissionState_h
#define RemoteEntityTransmissionState_h

typedef NS_ENUM(NSInteger, RemoteEntityTransmissionState) {
	RemoteEntityTransmissionStateUpToDate,
	RemoteEntityTransmissionStateUpdated,
	RemoteEntityTransmissionStateCreated,
	RemoteEntityTransmissionStateDeleted,
	RemoteEntityTransmissionStateInSyncError
};

#endif /* RemoteEntityTransmissionState_h */
