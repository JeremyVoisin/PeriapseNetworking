//
//  RemoteEntityAttributesTransformer.m
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 11/05/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import "RemoteEntityAttributesTransformer.h"
#import "RemoteEntityMapper.h"
#import "RemoteEntityAttributesTransformerAdditions.h"


@implementation RemoteEntityAttributesTransformer

+ (id) withManager:(RemoteEntityManager*)manager{
	RemoteEntityAttributesTransformer* attr = [super withManager:manager];
	[manager setAttributesTransformer:attr];
	return attr;
}

- (NSString*) toURLParamsFromDatas:(NSObject*)datas{
	return [datas toURLParamsWithURLBuilder:self.manager.urlBuilder];
}

- (NSObject*)transformRequestParamsWithAliases:(NSObject*)params{
	return [params transformRequestParamsWithAliasesWithManager:self.manager];
}

- (NSString*) toPredicateString:(NSDictionary*) _properties{
	NSDictionary* prop = (NSDictionary*)[self transformRequestParamsWithAliases:_properties];
	return [prop toPredicateStringWithManager:self.manager];
}

- (NSString*) identifierProperty{
	return @"id";
}

- (NSString*) toIndexSearchingPredicateString:(NSDictionary*) properties{
	NSString* toReturn = nil;
	if([[properties allKeys]containsObject:[self identifierProperty]]){
		NSPredicate *predicate =
		[NSComparisonPredicate
		 predicateWithLeftExpression:
		 [NSExpression expressionWithFormat:[self identifierProperty]]
		 rightExpression:
		 [NSExpression expressionForConstantValue:[properties objectForKey:[self identifierProperty]]]
		 modifier:NSDirectPredicateModifier
		 type:NSEqualToPredicateOperatorType
		 options:0];
		toReturn = [predicate predicateFormat];
	}
	return toReturn;
}

- (NSString*) toAbsentIndexSearchingPredicateString:(NSDictionary*) properties{
	return [NSString stringWithFormat:@" %@ == nil ",[self identifierProperty]];
}

- (NSArray*) toArray:(NSDictionary*) properties{
	return @[properties];
}

- (NSDictionary*) toIdentifierDictionary:(NSDictionary*) _properties{
	return @{[self identifierProperty]:[_properties objectForKey:[self identifierProperty]]};
}

- (NSDictionary*) toNoIdentifierDictionary:(NSDictionary*) _properties{
	NSMutableDictionary* toReturn = [_properties mutableCopy];
	[toReturn removeObjectForKey:[self identifierProperty]];
	return toReturn;
}

@end
