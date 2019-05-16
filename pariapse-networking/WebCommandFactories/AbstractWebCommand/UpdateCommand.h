//
//  UpdateCommand.h
//
//  Created by Jérémy Voisin on 06/01/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCommandProtocol.h"
#import "WebRequest.h"

@interface UpdateCommand : NSObject<WebCommandProtocol>

+(id)updateCommandWithURL:(NSString*)whereToSend andDatasToSend:(NSObject*)datas;

@end
