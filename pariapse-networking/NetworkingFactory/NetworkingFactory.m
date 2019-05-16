//
//  NetworkingFactory.m
//
//  Created by Jérémy Voisin on 18/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "NetworkingFactory.h"
#import "StandardWebCommandFactory.h"
#import "StandardWebRequestFactory.h"
#import "NetConfig.h"

@implementation NetworkingFactory

static NetworkingFactory* defaultNetworkingFactory = nil;

+ (NetworkingFactory*) defaultNetworkingFactory{
	return (defaultNetworkingFactory = ((defaultNetworkingFactory == nil)?[self networkingFactory]:defaultNetworkingFactory));
}

+(NetworkingFactory*)networkingFactory{
	NetworkingFactory* this = [[NetworkingFactory alloc]init];
	return this;
}

- (WebCommandFactory*)getWebCommandFactory{
	NSString* factoryName = [[NetConfig getConfig] objectForKey:@"WebCommandFactoryType"];
	return (_webCommandFactory = (_webCommandFactory != nil)? _webCommandFactory : (factoryName == nil)?[[StandardWebCommandFactory alloc]init]:[[NSClassFromString (factoryName) alloc]init]);
}

- (WebRequestFactory*)getWebRequestFactory{
	NSString* factoryName = [[NetConfig getConfig] objectForKey:@"WebRequestFactoryType"];
	_webRequestFactory = (_webRequestFactory != nil) ? _webRequestFactory : (factoryName == nil)?[[StandardWebRequestFactory alloc]init]:[[NSClassFromString (factoryName) alloc]init];
	return _webRequestFactory;
}

@end
