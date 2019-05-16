//
//  NetConfig.h
//
//  Created by Jérémy Voisin on 04/04/2016.
//  Copyright © 2016 jeyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestSerializerProtocol.h"


@interface NetConfig : NSObject

+(NSDictionary*)getConfig;
+(NSObject*)getConfigFor:(NSString*)configName;
+ (Class<WebRequestSerializerProtocol>) getWebRequestSerializer;
@end
