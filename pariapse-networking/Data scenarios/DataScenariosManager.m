//
//  DataScenariosManager.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 18/04/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "DataScenariosManager.h"

@interface DataScenariosManager()

@property (atomic,strong) NSMutableDictionary *dataScenariosNamedEntities;
@property (atomic,strong) NSMutableArray *dataScenariosEntities;

@end

@implementation DataScenariosManager
static DataScenariosManager* instance;
@synthesize dataScenariosEntities;
@synthesize dataScenariosNamedEntities;

+(DataScenariosManager*)defaultScenariosManager{
	return (instance = (instance == nil)?[self scenariosManager]:instance);
}

+(DataScenariosManager*)scenariosManager{
	DataScenariosManager* this = [[DataScenariosManager alloc]init];
	this.dataScenariosNamedEntities = [NSMutableDictionary dictionary];
	this.dataScenariosEntities = [NSMutableArray array];
	return this;
}

- (void) resetScenarios{
	for(NSMutableArray* arr in [dataScenariosNamedEntities allValues]){
		for(NSMutableArray* arr2 in arr){
			[arr2 removeAllObjects];
		}
		[arr removeAllObjects];
	}
	[dataScenariosNamedEntities removeAllObjects];
	[dataScenariosEntities removeAllObjects];
}

-(NSArray*)getRootEntities{
	NSMutableArray* arrayToReturn = [NSMutableArray array];
	for(NSString* str in [dataScenariosNamedEntities allKeys]){
		[arrayToReturn addObjectsFromArray:[self getEntitiesForKey:str]];
	}
	[arrayToReturn addObjectsFromArray: dataScenariosEntities];
	return arrayToReturn;
}

- (long)getRootEntitiesNumberForKey:(NSString*)key{
	long toReturn = 0;
	if(key == nil)toReturn = [dataScenariosEntities count];
	else if([[dataScenariosNamedEntities allKeys]containsObject:key]){
		toReturn = [[[dataScenariosNamedEntities objectForKey:key]firstObject]count];
	}
	return toReturn;
}

-(NSArray*)getEntitiesForKey:(NSString*)key{
	NSArray* toReturn = [NSArray array];
	if(key == nil)toReturn = dataScenariosEntities;
	else if([[dataScenariosNamedEntities allKeys]containsObject:key]){
		__strong NSMutableArray* currentObject = [[dataScenariosNamedEntities objectForKey:key]firstObject];
		for(__strong id<DataScenariosEntity> object in currentObject){
			if([object independency]){
				[currentObject removeObject:object];
				[object setIdentifier:nil];
				[dataScenariosEntities addObject:object];
			}
		}
		toReturn = [NSArray arrayWithArray: currentObject];
	}
	return toReturn;
}

-(void)addEntity:(id<DataScenariosEntity>)entity independency:(BOOL)independency{
	[self addEntity:entity async:NO independency:independency];
}

-(void)addEntity:(id<DataScenariosEntity>)entity async:(BOOL)async{
	[self addEntity:entity async:async independency:NO];
}

-(void)addEntity:(id<DataScenariosEntity>)entity{
	if([entity identifier] == nil) {
		[dataScenariosEntities addObject:entity];
	}else{
		if(![[dataScenariosNamedEntities allKeys]containsObject:[entity identifier]]){
			[dataScenariosNamedEntities setObject:[NSMutableArray array] forKey:[entity identifier]];
		}
		
		NSMutableArray *currentNamedScenario = [dataScenariosNamedEntities objectForKey:[entity identifier]];
		
		if([currentNamedScenario count] == 0 || ![entity async]){
			[currentNamedScenario addObject:[NSMutableArray array]];
		}
		[[currentNamedScenario lastObject] addObject:entity];
	}
}

-(void)addEntity:(id<DataScenariosEntity>)entity async:(BOOL)async independency:(BOOL)independency{
	[entity setAsync:async];
	[entity setIndependency:independency];
	[self addEntity:entity];
}

-(void)removeEntity:(id<DataScenariosEntity>)entity{
	if([entity identifier] == nil && [dataScenariosEntities containsObject:entity]){
		[dataScenariosEntities removeObject:entity];
	}
	else if([entity identifier] != nil && [[dataScenariosNamedEntities allKeys]containsObject:[entity identifier]]){
		NSMutableArray* entityContainer = [dataScenariosNamedEntities objectForKey:[entity identifier]];
		if([[entityContainer firstObject] containsObject:entity]){
			[[entityContainer firstObject] removeObject:entity];
			if([[entityContainer firstObject] count] == 0){
				[entityContainer removeObject:[entityContainer firstObject]];
				if([entityContainer count] == 0){
					[dataScenariosNamedEntities removeObjectForKey:[entity identifier]];
				}
			}
		}
	}
}

- (NSString *)description{
	NSMutableString* toReturn = [NSMutableString string];
	for(NSString* key in [dataScenariosNamedEntities allKeys]){
		[toReturn appendFormat:@"%@ => ",key];
		int i = 0;
		NSArray* arr2 = [dataScenariosNamedEntities objectForKey:key];
		for(NSArray* arr in arr2){
			i++;
			for(id<DataScenariosEntity> entity in arr){
				[toReturn appendFormat:@"%@",[entity description]];
			}
		}
	}
	return toReturn;
}

#pragma NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		if(self.dataScenariosNamedEntities == nil)
			self.dataScenariosNamedEntities = [decoder decodeObjectForKey:@"dataScenariosNamedEntities"];
		else{
			NSDictionary* namedEntities = [decoder decodeObjectForKey:@"dataScenariosNamedEntities"];
			for(NSString* name in [namedEntities allKeys]){
				NSMutableArray* entities = [namedEntities objectForKey: name];
				if([[[self dataScenariosNamedEntities] allKeys] containsObject: name])
					[entities addObjectsFromArray: [[self dataScenariosNamedEntities] objectForKey: name]];
				[self.dataScenariosNamedEntities setObject: entities forKey: name];
			}
		}
		if(self.dataScenariosEntities == nil)
			self.dataScenariosEntities = [decoder decodeObjectForKey:@"dataScenariosEntities"];
		else{
			NSMutableArray* entities = [decoder decodeObjectForKey:@"dataScenariosEntities"];
			[entities addObjectsFromArray: self.dataScenariosEntities];
			self.dataScenariosEntities = entities;
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:dataScenariosNamedEntities forKey:@"dataScenariosNamedEntities"];
	[encoder encodeObject:dataScenariosEntities forKey:@"dataScenariosEntities"];
}

@end
