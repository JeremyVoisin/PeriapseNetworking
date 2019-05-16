//
//  RemoteEntityManageable.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityManageable.h"

@implementation RemoteEntityManageable

+ (id) withManager:(RemoteEntityManager*)manager{
	return [[self.class alloc]initWithManager:manager];
}

-(id)initWithManager:(RemoteEntityManager*)manager{
	self = [self init];
	self.manager = manager;
	self.contexte = manager.context;
	return self;
}

@end
