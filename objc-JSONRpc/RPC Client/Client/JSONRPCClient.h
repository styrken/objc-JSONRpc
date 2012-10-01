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
 * Handles calling of RPCRequest callbacks and generates RPCResponse/RPCError objects.
 *
 * Retains requests while they are completing and manages calling of callback's.
 */
@interface JSONRPCClient : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

#pragma mark - Properties -
/**
 * What service endpoint we talk to. Just a simple string containing an URL. 
 * It will later be converted to an NSURL Object, so anything that NSURL Supports
 * is valid
 *
 */
@property (nonatomic, retain) NSString *serviceEndpoint;

/**
 * All the reqeusts that is being executed is added to this statck
 *
 */
@property (nonatomic, retain) NSMutableDictionary *requests;

/**
 * All returned data from the server is saved into this dictionary for later processing
 * 
 */
@property (nonatomic, retain) NSMutableDictionary *requestData;

#pragma mark - Methods

/**
 * Inits RPC Client with a specific end point.
 *
 * @param NSString endpoint Should be some kind of standard URL
 * @return RPCClient
 */
- (id) initWithServiceEndpoint:(NSString*) endpoint;

/**
 * Posts requests to the server via HTTP post. Always uses multicall to simplify handling
 * of responses.
 * 
 * If the server your talking with do not understand multicall then you have a problem.
 * 
 * TODO: Fallback to single call if server not supports multicall
 */
- (void) postRequests:(NSArray*)requests;

@end
