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

- (void) batch:(RPCRequest*) request, ...;

@end
