//
//  RPCBaseClient.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RPCRequest.h"
#import "RPCResponse.h"
#import "RPCError.h"

typedef void (^RPCCompletedCallback)(RPCResponse *response);

/**
 * This is the RPC Client base class. 
 * It provides methods to invoke methods against the server but it cannot parse and handle data
 * directly with an RPC server. This is what subclasses a for.
 *
 * F.example the RPCJSONClient handles JSON RPC's just fine.
 *
 */
@interface RPCBaseClient : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

#pragma mark - Properties -
/**
 * What service endpoint we talkt o
 *
 */
@property (nonatomic, retain) NSString *serviceEndpoint;


/**
 * Currently actively running connection
 *
 */
@property (nonatomic, retain) NSMutableDictionary *connections;


/**
 * All the callback that can be executed is added to this statck
 *
 */
@property (nonatomic, retain) NSMutableDictionary *callbacks;

#pragma mark - Methods
/**
 * Inits RPC Client with a specific end point
 *
 * @param NSString endpoint Should be some kind of standard URL
 * @return RPCClient
 */
- (id) initWithServiceEndpoint:(NSString*) endpoint;

/**
 * Invokes a RPCRequest against the end point
 *
 * @param RPCRequest reqeust The request to invoke
 * @param RPCCompletedCallback A callback method to invoke when request is done (or any error accours)
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(RPCRequest*) request onCompleted:(RPCCompletedCallback)callback;

/**
 * Invokes a method against the end point
 *
 * @param NSString method The method to invoke
 * @param id Either named or un-named parameter list (or nil)
 * @param RPCCompletedCallback A callback method to invoke when request is done (or any error accours)
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(NSString*) method params:(id) params  onCompleted:(RPCCompletedCallback)callback;

@end

/**
 * These methods needs to be impleted by subclasses to use the RPC Base Client
 *
 */
@interface RPCBaseClient ()
/**
 * Serializes a request to anything that can be send over http post, if anything fails one must set error
 *
 * @param RPCRequest request The request to serialize
 * @param RPCError error If any error accours
 * @return NSData Serialized RPCRequest as NSData object
 */
- (NSData*) serializeRequest:(RPCRequest*) request error:(RPCError **) error;

/**
 * Parses the result from the server, must return some kind of objective-c object
 *
 * @param NSData data The data to parse
 * @param RPCError error If any error accours
 * @return id Any kind of objective-c object that matches data in NSData parameter
 */
- (id) parseResult:(NSData*) data error:(RPCError **) error;

/**
 * Should tell anything about the content-type that we send over http post request
 *
 * @return NSString
 */
- (NSString*) contentType;
@end
