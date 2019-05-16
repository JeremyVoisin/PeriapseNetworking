//
//  WebRequestPoolItem.h
//
//  Created by Jérémy Voisin on 15/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestPoolItemDelegate.h"
#import "WebResponseHandlerProtocol.h"
#import "DataScenariosEntity.h"
#import "WebRequestURLPropertyProtocol.h"
#import "WebCommandProtocol.h"

@class RequestConsistencyRule;

@interface WebRequestPoolItem : NSObject<DataScenariosEntity>

@property id<WebCommandProtocol> command;
@property id<WebResponseHandlerProtocol> responseHandler;
@property id<WebRequestPoolItemDelegate> delegate;
@property NSMutableSet* consistencyRules;
@property BOOL cancelExecution;

- (id<WebRequestPoolItemDelegate>)delegate;
- (void) setDelegate:(id<WebRequestPoolItemDelegate>)newDelegate;
- (void) execute;
- (BOOL) setReady;
- (BOOL) wontEnd;
- (void) setRequestProperty:(id<WebRequestURLPropertyProtocol>)property;
- (void) setRequestProperties:(NSSet*)properties;
- (int) getPriority;
- (void) setPriority:(int)priority;
- (void) addConsistencyRules:(RequestConsistencyRule*)rule;

+(WebRequestPoolItem*) createPoolItemWithCommand:(id<WebCommandProtocol>)command withResponseHandler:(id<WebResponseHandlerProtocol>)resHandler;
 
@end
