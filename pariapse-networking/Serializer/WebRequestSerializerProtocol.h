//
//  WebRequestSerializerProtocol.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 01/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebRequestSerializerProtocol <NSObject>

@required
- (id) parseDatas: (NSData*) datas;
- (id) encodeDatas: (id) datas;

@end
