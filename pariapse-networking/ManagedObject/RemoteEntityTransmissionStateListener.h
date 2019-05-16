//
//  RemoteEntityTransmissionStateListener.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 31/10/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntityTransmissionStateListener.h"

@class RemoteEntity;

@protocol RemoteEntityTransmissionStateListener <NSObject>

@required
- (void) remoteEntity: (RemoteEntity*) entity transmissionStateChangedTo: (RemoteEntityTransmissionState) state;

@end
