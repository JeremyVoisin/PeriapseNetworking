/*!
 * @file JSONWebRequestSerializer.m
 * @framework PeriapseNetworking

 * @author Jérémy Voisin
 * @copyright © 2019 Jérémy Voisin
 * @version 1.0
 */

#import "JSONWebRequestSerializer.h"

/*!
 * @class JSONWebRequestSerializer
 * @brief This class serializes/deserializes the JSON received from a web request.
 *
 * The JSONWebRequestSerializer conforms to WebRequestSerializerProtocol
 */
@implementation JSONWebRequestSerializer

/*!
 * @brief This method is called for json deserialization when a response is received from a web request
 * @param The JSON NSData coming from the web request response
 * @return The deserialized object
 */
- (id) parseDatas: (NSData*) datas{
	if(datas != nil)
		return [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
	return [NSMutableArray array];
}

/*!
 * @brief This method is called for json serialization before sending a web request
 * @param The object to serialize in json
 * @return The json to send in a web request
 */
- (id) encodeDatas: (id) datas{
	return [NSJSONSerialization dataWithJSONObject:datas options:0 error:nil];
}

@end
