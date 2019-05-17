/*!
 * @header JSONWebRequestSerializer.m
 * @framework PeriapseNetworking

 * @author Jérémy Voisin
 * @copyright © 2019 Jérémy Voisin
 * @version 1.0
 */

#import <Foundation/Foundation.h>
#import "WebRequestSerializerProtocol.h"

/*!
 * @interface JSONWebRequestSerializer
 * @brief This class serializes/deserializes the JSON received from a web request.
 *
 * The JSONWebRequestSerializer conforms to WebRequestSerializerProtocol
 */
@interface JSONWebRequestSerializer : NSObject<WebRequestSerializerProtocol>
@end
