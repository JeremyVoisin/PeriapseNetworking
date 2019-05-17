/*!
 * @header WebRequestSerializerProtocol.h
 * @framework PeriapseNetworking

 * @author Jérémy Voisin
 * @copyright © 2019 Jérémy Voisin. All rights reserved.
 * @version 1.0
 */

#import <Foundation/Foundation.h>

/*!
 * @protocol WebRequestSerializerProtocol
 * @brief This protocol standardizes the serialization classes
 */
@protocol WebRequestSerializerProtocol <NSObject>

@required
/*!
 * @brief This method is called for data deserialization when a response is received from a web request
 * @param The NSData coming from the web request response
 * @return The deserialized object
 */
- (id) parseDatas: (NSData*) datas;

/*!
 * @brief This method is called for data serialization before sending a web request
 * @param The object to serialize
 * @return The serialized data to send in a web request
 */
- (id) encodeDatas: (id) datas;

@end
