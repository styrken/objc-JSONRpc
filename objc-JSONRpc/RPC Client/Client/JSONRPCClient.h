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
@property (nonatomic, retain) NSMutableDictionary *requestData;

#pragma mark - Methods
/**
 * Inits RPC Client with a specific end point
 *
 * @param NSString endpoint Should be some kind of standard URL
 * @return RPCClient
 */
- (id) initWithServiceEndpoint:(NSString*) endpoint;

- (void) postRequests:(NSArray*)requests;

@end
