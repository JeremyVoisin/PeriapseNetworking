//
//  ReadCommand.h
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCommandProtocol.h"
#import "ReadRequest.h"

@interface ReadCommand : NSObject<WebCommandProtocol>

+(id)readCommandWithURL:(NSString*)whereToSend;

@end
