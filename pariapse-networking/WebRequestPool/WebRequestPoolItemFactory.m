//
//  WebRequestPoolItemFactory.m
//
//  Created by Jérémy Voisin on 06/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "WebRequestPoolItemFactory.h"
#import "WebRequestPool.h"
#import "WebResponseHandlerProtocol.h"

@implementation WebRequestPoolItemFactory

+ (WebRequestPoolItemFactory*) webRequestPoolItemFactory{
	return [[WebRequestPoolItemFactory alloc]init];
}

- (WebRequestPoolItem*)readFromURL:(NSString*)url withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler{
	
	ReadCommand *rc = [[[NetworkingFactory defaultNetworkingFactory]getWebCommandFactory] readCommandWithURL:url];
	
	WebRequestPoolItem* wrpi =[WebRequestPoolItem createPoolItemWithCommand:rc withResponseHandler: responseHandler];
	
	[wrpi setDelegate:[WebRequestPool defaultWebRequestPool]];
	
	return wrpi;
}

- (WebRequestPoolItem*)deleteFromURL:(NSString*)url withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler{
	
	DeleteCommand *rc = [[[NetworkingFactory defaultNetworkingFactory]getWebCommandFactory] deleteCommandWithURL:url];
	
	WebRequestPoolItem* wrpi =[WebRequestPoolItem createPoolItemWithCommand:rc withResponseHandler: responseHandler];
	
	[wrpi setDelegate:[WebRequestPool defaultWebRequestPool]];
	
	return wrpi;
}
- (WebRequestPoolItem*)postToURL:(NSString*)url withDatasToSend:(NSObject*)datas withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler{
	
	PostCommand *rc = [[[NetworkingFactory defaultNetworkingFactory]getWebCommandFactory] postCommandWithURL:url andDatasToSend:datas];
	
	WebRequestPoolItem* wrpi =[WebRequestPoolItem createPoolItemWithCommand:rc withResponseHandler: responseHandler];
	
	[wrpi setDelegate:[WebRequestPool defaultWebRequestPool]];
	
	return wrpi;
}


- (WebRequestPoolItem*)updateWithURL:(NSString*)url withDatasToSend:(NSObject*)datas withResponseHandler: (id<WebResponseHandlerProtocol>)responseHandler{
	
	UpdateCommand *rc = [[[NetworkingFactory defaultNetworkingFactory]getWebCommandFactory] updateCommandWithURL:url andDatasToSend:datas];
	
	WebRequestPoolItem* wrpi =[WebRequestPoolItem createPoolItemWithCommand:rc withResponseHandler: responseHandler];
	
	[wrpi setDelegate:[WebRequestPool defaultWebRequestPool]];
	
	return wrpi;
}

@end
