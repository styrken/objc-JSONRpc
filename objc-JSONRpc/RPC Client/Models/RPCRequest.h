//
//  RPCRequest.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPCResponse;

// Callback type
typedef void (^RPCRequestCallback)(RPCResponse *response);

/**
 * RPC Request object. 
 *
 * Always used to invoke a request to an endpoint. Contains information about the request that you send to a server.
 * This object is kept alive untill the request is finished.
 */
@interface RPCRequest : NSObject

#pragma mark - Properties -

/**
 * The used RPC Version. 
 * This client only supports version 2.0 at the moment.
 *
 * @param NSString
 */
@property (nonatomic, retain) NSString *version;

/**
 * The id that was used in the request. If id is nil the request is treated like an  notification.
 *
 * @param NSString
 */
@property (nonatomic, retain) NSString *id;

/**
 * Method to call at the RPC Server.
 *
 * @param NSString 
 */
@property (nonatomic, retain) NSString *method;

/**
 * Request params. Either named, un-named or nil
 *
 * @param id
 */
@property (nonatomic, retain) id params;

/**
 * Callback to call whenever request is fininshed
 *
 * @param RPCRequestCallback
 */
@property (nonatomic, copy) RPCRequestCallback callback;

#pragma mark - methods

/**
 * Serialized requests object for json encodig
 *
 */
- (NSMutableDictionary*) serialize;

/**
 * Helper method to get an autoreleased request object
 *
 * @param NSString method The method that this request if for
 * @return RPCRequest (autoreleased)
 */
+ (id) requestWithMethod:(NSString*) method;

/**
 * Helper method to get an autoreleased request object 
 *
 * @param NSString method The method that this request if for
 * @param id params Some parameters to send along with the request, either named, un-named or nil
 * @return RPCRequest (autoreleased)
 */
+ (id) requestWithMethod:(NSString*) method params:(id) params;

/**
 * Helper method to get an autoreleased request object
 *
 * @param NSString method The method that this request if for
 * @param id params Some parameters to send along with the request, either named, un-named or nil
 * @param RPCRequestCallback the callback to call once the request is finished
 * @return RPCRequest (autoreleased)
 */
+ (id) requestWithMethod:(NSString*) method params:(id) params callback:(RPCRequestCallback)callback;

@end
