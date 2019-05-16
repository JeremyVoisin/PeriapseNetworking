//
//  DeleteCommand.h
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeleteRequest.h"
#import "WebCommandProtocol.h"

@interface DeleteCommand : NSObject<WebCommandProtocol>

+(id)deleteCommandWithURL:(NSString*)whereToSend;

@end
