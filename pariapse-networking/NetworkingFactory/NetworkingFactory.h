//
//  NetworkingFactory.h
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCommandFactory.h"
#import "WebRequestFactory.h"

@interface NetworkingFactory : NSObject

@property WebRequestFactory* webRequestFactory;
@property WebCommandFactory* webCommandFactory;

+ (NetworkingFactory*)defaultNetworkingFactory;
- (WebCommandFactory*)getWebCommandFactory;
- (WebRequestFactory*)getWebRequestFactory;

@end
