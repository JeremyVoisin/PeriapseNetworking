//
//  NetworkStateHelper.m
//
//  Created by Jérémy Voisin on 31/03/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "NetworkStateHelper.h"
#import "Reachability.h"

@implementation NetworkStateHelper

+(BOOL)cellularConnected{
	
	SCNetworkReachabilityFlags  flags = 0;
	SCNetworkReachabilityRef netReachability;
	netReachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"google.com" UTF8String]);
	if(netReachability)
	{
		SCNetworkReachabilityGetFlags(netReachability, &flags);
		CFRelease(netReachability);
	}
	if(flags & kSCNetworkReachabilityFlagsIsWWAN) return YES;
	return NO;
}
	
+ (NetworkState) networkType{
	return ([self wiFiConnected]?WIFI:([NetworkStateHelper cellularConnected]?CELLULAR:DOWN));
}

+(BOOL)networkConnected{
	
	SCNetworkReachabilityFlags flags = 0;
	SCNetworkReachabilityRef netReachability;
	BOOL  retrievedFlags = NO;
	netReachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"google.com" UTF8String]);
	if(netReachability)
	{
		retrievedFlags  = SCNetworkReachabilityGetFlags(netReachability, &flags);
		CFRelease(netReachability);
	}
	if (!retrievedFlags || !flags) return NO;
	return YES;
}

+(BOOL) wiFiConnected{
	
	if ([self cellularConnected]) return NO;
	return [self networkConnected];
}

+(BOOL)isReachable{
	return [self wiFiConnected] || [self cellularConnected] || [self networkConnected];
}

@end
