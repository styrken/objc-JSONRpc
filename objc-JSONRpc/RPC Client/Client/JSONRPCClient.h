//
//  RPCJSONClient.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPCRequest.h"
#import "RPCError.h"
#import "RPCResponse.h"

/**
 * JSONRPCClient
 *
 * Provides means to communicate with the RPC server and is responsible of serializing/parsing requests
 * that is send and recieved.
 *
 * Retains requests while they are completing and manages calling of callback's.
 */
@interface JSONRPCClient : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

#pragma mark - Properties -
/**
 * What service endpoint we talkt o
 *
 */
@property (nonatomic, retain) NSString *serviceEndpoint;

/**
 * All the reqeusts that can be executed is added to this statck
 *
 */
@property (nonatomic, retain) NSMutableDictionary *requests;

#pragma mark - Methods
/**
 * Inits RPC Client with a specific end point
 *
 * @param NSString endpoint Should be some kind of standard URL
 * @return RPCClient
 */
- (id) initWithServiceEndpoint:(NSString*) endpoint;

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

@end
