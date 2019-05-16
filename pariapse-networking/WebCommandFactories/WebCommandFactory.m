//
//  WebCommandFactory.m
//
//  Created by Jérémy Voisin on 17/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import "WebCommandFactory.h"

@implementation WebCommandFactory

-(ReadCommand*)readCommandWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

-(UpdateCommand*)updateCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

-(DeleteCommand*)deleteCommandWithURL:(NSString*)url{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

-(PostCommand*)postCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Error, attempting to call Abstract method directly." userInfo:nil];
}

@end
