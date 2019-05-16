//
//  WebRequestPoolActivityListener.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 17/09/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebRequestPoolActivityListener <NSObject>

@required
- (void) webRequestPoolActivityStarted;
- (void) webRequestPoolActivityEnded;
- (void) webRequestPoolRequiresAuthentication;

@end
