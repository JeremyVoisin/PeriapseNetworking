//
//  WebCommandFactoryProtocol.h
//
//  Created by Jérémy Voisin on 17/02/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadCommand.h"
#import "UpdateCommand.h"
#import "DeleteCommand.h"
#import "PostCommand.h"

@protocol WebCommandFactoryProtocol <NSObject>

@required

-(ReadCommand*)readCommandWithURL:(NSString*)url;
-(UpdateCommand*)updateCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend;
-(DeleteCommand*)deleteCommandWithURL:(NSString*)url;
-(PostCommand*)postCommandWithURL:(NSString*)url andDatasToSend:(NSObject*)toSend;

@optional

@end
