//
//  NetworkStateDelegate.h
//
//  Created by Jérémy Voisin on 04/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkState.h"

@protocol NetworkStateSubscriber <NSObject>

@required

- (void)networkDidToggleToState:(NetworkState)networkState;

@end
