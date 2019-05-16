//
//  WebRequestPoolItemDelegate.h
//
//  Created by Jérémy Voisin on 06/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebRequestPoolItem;

@protocol WebRequestPoolItemDelegate <NSObject>

@required
-(void)webRequestPoolItem:(WebRequestPoolItem*)poolItem needsPoolActionOnWebRequestErrorWithCompletion:(void(^)(NSData*))completion;
-(void)webRequestPoolItemIsReady:(WebRequestPoolItem*)poolItem;
-(void)webRequestPoolItemSucceeded:(WebRequestPoolItem*)poolItem;
-(void)webRequestPoolItemWillNotEnd:(WebRequestPoolItem*)poolItem;

@end
