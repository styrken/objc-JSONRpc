//
//  JSONRPCClient+Invoke.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/29/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Multicall.h"
#import "JSONRPCClient+Invoke.h"
#import "JSONKit.h"

STATIC_CATEGORY(JSONRPCClient_Multicall)
@implementation JSONRPCClient (Multicall)

- (void) batch:(RPCRequest*) request, ...
{
    va_list argument_list;
    
    NSMutableArray *tmpRequests = [[NSMutableArray alloc] init];
    
    if(request)
        [tmpRequests addObject:request];
    
    va_start(argument_list, request);
    
    RPCRequest *r;
    while((r = va_arg(argument_list, RPCRequest*)))
        [tmpRequests addObject:r];
    
    va_end(argument_list);
    
    if(tmpRequests.count > 0 )
        [self postRequests:tmpRequests];
    
    [tmpRequests release];
}

@end
