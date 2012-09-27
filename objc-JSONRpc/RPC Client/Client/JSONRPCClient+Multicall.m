//
//  JSONRPCClient+Invoke.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/29/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Multicall.h"

@implementation JSONRPCClient (Multicall)


- (void) batch:(RPCRequest*) request, ...
{
    va_list args;
    va_start(args, request);
    
    // Do stuff with all the requests! If only one request, call standard invoke method
    
    
    va_end(args);
}

@end
