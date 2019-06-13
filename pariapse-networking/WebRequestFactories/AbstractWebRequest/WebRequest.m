//
//  WebRequest.m
//
//  Created by Jérémy Voisin on 16/09/2015.
//  Copyright (c) 2015 jeyz. All rights reserved.
//

#import "WebRequest.h"
#import "DeleteRequest.h"
#import "UpdateRequest.h"
#import "PostRequest.h"
#import "ReadRequest.h"
#import "NetConfig.h"
#import "WebRequestSerializerProtocol.h"


@implementation WebRequest

@synthesize url;
@synthesize toSend;
@synthesize httpStatus;
@synthesize response;
@synthesize isAsync;
@dynamic property;
@synthesize httpURLResponse;

+(NSArray*) abstractSuclasses{
	return @[[WebRequest class], [DeleteRequest class], [UpdateRequest class], [ReadRequest class],  [PostRequest class]];
}

- (id)init{
	if ([[self.class abstractSuclasses] containsObject:[self class]]) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException
									   reason:@"Error, attempting to instantiate AbstractWebRequest directly." userInfo:nil];
	}
	
	self = [super init];
	if (self) {
		isAsync = false;
	}
	
	return self;
}

- (id)initWithURL:(NSString*)thisUrl{
	self = [self init];
	if ([[self.class abstractSuclasses] containsObject:[self class]]) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException
				reason:@"Error, attempting to instantiate AbstractWebRequest directly." userInfo:nil];
	}
	self.property = [[WebRequestURLProperty alloc]init];
    url = thisUrl;
	isAsync = false;
    return self;
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
	if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
		NSArray* netTrusts = [[NetConfig getConfig] objectForKey:@"TrustedHosts"];
		if(netTrusts != nil && [netTrusts containsObject:challenge.protectionSpace.host]){
			NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
		}
	}
}

/*
 TODO : Implémentation du certificate spinning
 -(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
	
	// Get remote certificate
	SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
	SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
	
	// Set SSL policies for domain name check
	NSMutableArray *policies = [NSMutableArray array];
	[policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
	SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
	
	// Evaluate server certificate
	SecTrustResultType result;
	SecTrustEvaluate(serverTrust, &result);
	BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
	
	// Get local and remote cert data
	NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
	NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"github.com" ofType:@"cer"];
	NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
	
	// The pinnning check
	if ([remoteCertificateData isEqualToData:localCertificate] && certificateIsValid) {
		NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
		completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
	} else {
		completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
	}
}*/


-(void)sendRequestWithEndingBlock:(void (^)(void))completion{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}


- (void)handleResponse:(void (^)(void))completion withDatas:(NSData*)data andTheHTTPResponse:(NSURLResponse*)rep{
	
	NSHTTPURLResponse* resp = (NSHTTPURLResponse*)rep;
	httpURLResponse = resp;
	httpStatus = resp.statusCode;
	if(httpStatus >= 200 && httpStatus<=204){
		response = data;
	}
	else{
		response = nil;
	}
	dispatch_async( dispatch_get_main_queue(), ^{
		[completion invoke];
	});
}

/**
 Découpage de la réponse du serveur, reçue sous la forme de JSON
 */

- (id) parseJSON{
	return [self.class parseJSON: response];
}

+ (id<WebRequestSerializerProtocol>) getSerializer{
	Class parserClass = [NetConfig getWebRequestSerializer];
	return [parserClass new];
}

+ (id) parseJSON:(NSData*)response{
	id<WebRequestSerializerProtocol> jsonParser = [self getSerializer];
	return [jsonParser parseDatas: response];
}

+ (id) encodeInJSON:(id)toEncode{
	id<WebRequestSerializerProtocol> jsonParser = [self getSerializer];
	return [jsonParser encodeDatas: toEncode];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.url = [decoder decodeObjectForKey:@"url"];
		self.toSend = [decoder decodeObjectForKey:@"toSend"];
		self.isAsync = [decoder decodeBoolForKey:@"isAsync"];
		self.property = [decoder decodeObjectForKey:@"wrProperty"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:url forKey:@"url"];
	[encoder encodeObject:toSend forKey:@"toSend"];
	[encoder encodeBool:isAsync forKey:@"isAsync"];
	[encoder encodeObject:self.property forKey:@"wrProperty"];
}


@end
