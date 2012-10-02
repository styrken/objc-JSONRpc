//
//  JSONRPCClient+Invoke.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/29/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient.h"

/**
 * Multicall
 *
 * - Adds invoking of multicalls to the remote server through the jsonrpcclient class
 */
@interface JSONRPCClient (Multicall)

/**
 * Sends  batch of RPCRequest objects to the server. The call to this method must be nil terminated.
 * 
 * @param RPCRequest request The first request to send
 * @param ...A list of RPCRequest objects to send, must be nil terminated
 */
- (void) batch:(RPCRequest*) request, ...;

@end
