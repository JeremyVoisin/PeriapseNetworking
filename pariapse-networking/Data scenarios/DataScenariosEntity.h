//
//  DataScenariosEntity.h
//  PeriapseNetworking
//
//  Created by Jérémy Voisin on 18/04/2016.
//  Copyright © 2016 Jérémy Voisin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataScenariosEntity <NSObject, NSCoding>

@required
@property NSString* identifier;
@property BOOL async;
@property BOOL independency;

@end
