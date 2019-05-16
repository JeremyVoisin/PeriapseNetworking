//
//  ReadRequest.m
//
//  Created by Jérémy Voisin on 10/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "ReadRequest.h"

@implementation ReadRequest

-(void) sendRequestWithEndingBlock:(void(^ _Nonnull)(void))completion{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

-(void) getDataWithCompletionHandler:(void(^ _Nonnull)(void))completion{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

- (void) asynchronousRequestWithCompletionHandler:(void(^ _Nonnull)(void))completion{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

@end
