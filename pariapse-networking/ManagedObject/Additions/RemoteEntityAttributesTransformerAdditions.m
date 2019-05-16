//
//  RemoteEntityAttributesTransformerAdditions.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 21/07/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityAttributesTransformerAdditions.h"
#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityAliasManager.h"
#import "RemoteEntityAttributesTransformerAdditions.h"
#import "RemoteEntityQueryComparatorManager.h"

@implementation NSObject(RemoteEntityAddition)

- (NSObject*)transformRequestParamsWithAliasesWithManager:(RemoteEntityManager*) entityManager{
	return self;
}

- (NSString*) toURLParamsWithURLBuilder:(RemoteEntityURLBuilder*)urlBuilder{
	return [self toURLParamsWithFirstPass:YES andTitle:nil andURLBuilder:urlBuilder];
}

- (NSString*) toURLParamsWithFirstPass:(BOOL)firstPass andTitle:(NSString*)title andURLBuilder:(RemoteEntityURLBuilder*)urlBuilder{
	return [NSString stringWithFormat:[urlBuilder getURLParamsFormat],[self getURLMarkerWithFirstPass:firstPass andURLBuilder:urlBuilder],title,self];
}

- (NSString*) getURLMarkerWithFirstPass:(BOOL)firstPass andURLBuilder:(RemoteEntityURLBuilder*)urlBuilder{
	NSString* marker;
	if(firstPass){
		marker = [urlBuilder getURLFirstPassMarker];
	}else marker = [urlBuilder getURLNotFirstPassMarker];
	return marker;
}

- (NSString*) toPredicateStringWithManager:(RemoteEntityManager*)manager{
	return [self toPredicateStringWithPrefix:@"" andManager:manager];
}

- (NSString*) toPredicateStringWithPrefix:(NSString *)prefix andManager:(RemoteEntityManager*)manager{
	return [NSString stringWithFormat: @"%@ %@ \"%@\"", prefix,[manager.queryComparatorManager getQueryComparatorFromPropertyName:prefix],self];
}

- (BOOL)testEqualityWith:(id)object{
	return [self isEqual:object];
}

@end

@implementation NSNumber(RemoteEntityAddition)

- (BOOL)testEqualityWith:(NSNumber*)num{
	return [self isEqualToNumber:num];
}

@end

@implementation NSString(RemoteEntityAddition)

- (NSString*)getPrefixWithPreviousPrefix:(NSString*)previousPrefix{
	return ([previousPrefix isEqualToString:@""])?self:[NSString stringWithFormat:@"%@.%@",previousPrefix,self];
}

- (BOOL)testEqualityWith:(NSString*)string{
	return [self isEqualToString:string];
}

@end

@implementation NSDictionary(RemoteEntityAddition)

- (NSDictionary*)transformRequestParamsWithAliasesWithManager:(RemoteEntityManager*) entityManager{
	NSMutableDictionary* toReturn = [NSMutableDictionary dictionary];
	for(NSString* keys in [self allKeys]){
		if(![entityManager.mapper isPropertyExisting: keys]){
			NSString* propertyName = [entityManager.aliasManager getPropertyNameFromAlias:keys];
			if([entityManager.mapper isPropertyExisting:propertyName]){
				[toReturn setObject:[self objectForKey:keys] forKey:propertyName];
			}
		}else{
			[toReturn setObject:[self objectForKey:keys] forKey:keys];
		}
	}
	return toReturn;
}

- (NSString*) toPredicateStringWithPrefix:(NSString *)prefix andManager:(RemoteEntityManager*)manager{
	NSMutableString* predicateString = [NSMutableString string];
	BOOL firstPass = true;
	for(NSString* key in [self allKeys]){
		if(!firstPass)[predicateString appendString:@" AND "];
		else firstPass = false;
		[predicateString appendString:[[self objectForKey:key] toPredicateStringWithPrefix:[key getPrefixWithPreviousPrefix:prefix] andManager:manager]];
	}
	return predicateString;
}

- (NSString*) toURLParamsWithFirstPass:(BOOL)firstPass andTitle:(NSString*)title andURLBuilder:(RemoteEntityURLBuilder *)urlBuilder{
	NSMutableString* urlString = [NSMutableString string];
	if([[self allKeys] count] == 0)urlString = [@"" mutableCopy];
	else{
		for(NSString* key in [self allKeys]){
			NSObject* obj = [self objectForKey:key];
			[urlString appendString:[obj toURLParamsWithFirstPass:firstPass andTitle:key andURLBuilder:urlBuilder]];
			firstPass = false;
		}
	}
	return urlString;
}

@end

@implementation NSArray(RemoteEntityAddition)

- (NSArray*)transformRequestParamsWithAliasesWithManager:(RemoteEntityManager*) entityManager{
	NSMutableArray* toReturn = [NSMutableArray array];
	for(NSObject* obj in self){
		[toReturn addObject:[obj transformRequestParamsWithAliasesWithManager:entityManager]];
	}
	return toReturn;
}

- (NSString*)toPredicateStringWithPrefix:(NSString *)prefix andManager:(RemoteEntityManager*)manager{
	NSMutableString* predicateString = [NSMutableString string];
	BOOL firstPass = true;
	for(NSObject* obj in self){
		if(!firstPass)[predicateString appendString:@") OR ("];
		else{
			firstPass = false;
			[predicateString appendString:@"(("];
		}
		[predicateString appendString:[obj toPredicateStringWithPrefix:prefix andManager:manager]];
	}
	[predicateString appendString:@"))"];
	return predicateString;
}

- (NSString*) toURLParamsWithFirstPass:(BOOL)firstPass andTitle:(NSString*)title andURLBuilder:(RemoteEntityURLBuilder *)urlBuilder{
	NSMutableString* urlString = [NSMutableString string];
	for(NSObject* obj in self){
		[urlString appendString: [obj toURLParamsWithFirstPass:firstPass andTitle:title andURLBuilder:urlBuilder]];
		firstPass = false;
	}
	return urlString;
}

- (BOOL)testEqualityWith:(NSArray*)array{
	BOOL toReturn = true;
	for(NSObject* obj in array){
		if(![obj testEqualityWith:obj]){
			toReturn = false;
			break;
		}
	}
	return toReturn;
}

@end
