//
//  WebRequestPoolItem.m
//
//  Created by Jérémy Voisin on 15/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebRequestPoolItem.h"
#import "RequestConsistencyRule.h"

@implementation WebRequestPoolItem

@synthesize identifier;
@synthesize independency;
@synthesize async;
@synthesize command;
@synthesize delegate;

static NSString* kAuthenticationNeededNotification = @"kAuthenticationNeededNotification";


+(WebRequestPoolItem*) createPoolItemWithCommand:(id<WebCommandProtocol>)command withResponseHandler:(id<WebResponseHandlerProtocol>)resHandler{
	WebRequestPoolItem* wrpi = [[WebRequestPoolItem alloc]init];
	wrpi.consistencyRules = [NSMutableSet set];
	wrpi.command = command;
	wrpi.cancelExecution = NO;
	wrpi.responseHandler = resHandler;
	return wrpi;
}

- (void)execute{
		[self applyConsistencyRules];
		if(!self.cancelExecution){
#ifdef VERBOSE_MODE
			NSLog(@"Calling %@",self.command.webRequest.url);
#endif
			[command executeWithOnSuccess:^(NSData *response){
				[self.responseHandler onSuccess: response withWRPI: self];
				if(self.delegate != nil){
					[self.delegate webRequestPoolItemSucceeded: self];
				}
			} onError:^(NSUInteger httpError, NSHTTPURLResponse* urlError) {
				if(self.delegate != nil){
					[self.delegate webRequestPoolItem:self needsPoolActionOnWebRequestErrorWithCompletion:^(NSData *resp) {
						if(resp == nil){
							if(httpError == 401){
								[self notifyAuthenticationNeeded];
							}
							[self.responseHandler onError:httpError withURLResponse:urlError withWRPI: self];
						}else{
							[self.responseHandler onSuccess: resp withWRPI: self];
						}
					}];
				}
				else if(httpError == 401){
					[self notifyAuthenticationNeeded];
				}
			}];
		}else{
			[self wontEnd];
		}
	
}

- (void) notifyAuthenticationNeeded{
	[[NSNotificationCenter defaultCenter] postNotificationName: kAuthenticationNeededNotification object: nil];
}

- (void)alertWithErrorMessage:(id)message{
	/*UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Erreur réseau"
																  message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {}];
 
	[alert addAction:defaultAction];*/
	NSLog(@"%@",message);
}

- (void) addConsistencyRules:(RequestConsistencyRule*)rule{
	[_consistencyRules addObject:rule];
}

- (void) applyConsistencyRules{
	for(RequestConsistencyRule* rule in _consistencyRules){
		if(![rule checkConsistencyOfWRPI:self]){
			[rule applyConsistencyToWRPI:self];
		}
	}
}

- (int)getPriority{
	return [command priority];
}

- (void)setPriority:(int)priority{
	return [command setPriority:priority];
}

- (BOOL)setReady{
	BOOL returnValue = NO;
	if(delegate != nil){
		[delegate webRequestPoolItemIsReady:self];
		returnValue = YES;
	}
	return returnValue;
}

- (BOOL)wontEnd{
	BOOL returnValue = NO;
	if(delegate != nil){
		[delegate webRequestPoolItemWillNotEnd:self];
		returnValue = YES;
	}
	return returnValue;
}
 
#pragma delegation
- (id<WebRequestPoolItemDelegate>)delegate {
	return delegate;
}

- (void)setDelegate:(id<WebRequestPoolItemDelegate>)newDelegate {
	delegate = newDelegate;
}

#pragma web request properties

-(void) setRequestProperty:(WebRequestURLProperty<WebRequestURLPropertyProtocol>*)property{
	[command.webRequest setProperty:property];
}

-(void) setRequestProperties:(NSSet*)properties{
	for(WebRequestURLProperty<WebRequestURLPropertyProtocol>* property in properties)
		[self setRequestProperty:property];
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.identifier = [decoder decodeObjectForKey:@"identifier"];
		self.command = [decoder decodeObjectForKey:@"command"];
		self.independency = [decoder decodeBoolForKey:@"independency"];
		self.responseHandler = [decoder decodeObjectForKey:@"responseHandler"];
		self.async = [decoder decodeBoolForKey:@"async"];
		self.consistencyRules = [decoder decodeObjectForKey:@"consistencyRules"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.command forKey:@"command"];
	[encoder encodeObject:self.identifier forKey:@"identifier"];
	[encoder encodeBool:self.independency forKey:@"independency"];
	[encoder encodeBool:self.async forKey:@"async"];
	[encoder encodeObject:self.consistencyRules forKey:@"consistencyRules"];
	[encoder encodeObject:self.responseHandler forKey:@"responseHandler"];
}

@end
