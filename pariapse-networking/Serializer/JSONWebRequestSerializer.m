//
//  JSONWebRequestSerializer.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 01/02/2017.
//  Copyright © 2017 Jérémy Voisin. All rights reserved.
//

#import "JSONWebRequestSerializer.h"

@implementation JSONWebRequestSerializer

- (id) parseDatas: (NSData*) datas{
	if(datas != nil)
		return [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
	return [NSMutableArray array];
}

- (id) encodeDatas: (id) datas{
	return [NSJSONSerialization dataWithJSONObject:datas options:0 error:nil];
}

@end
