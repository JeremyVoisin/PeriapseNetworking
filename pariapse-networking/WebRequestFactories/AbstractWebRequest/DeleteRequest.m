//
//  DeleteRequest.m
//
//  Created by Jérémy Voisin on 10/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "DeleteRequest.h"

@implementation DeleteRequest

-(void)sendRequestWithEndingBlock:(void (^)(void))completion{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

@end
